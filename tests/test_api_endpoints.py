import importlib.util
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location("preset_enhancer_server", ROOT / "server.py")
server = importlib.util.module_from_spec(spec)
spec.loader.exec_module(server)


class ApiEndpointTests(unittest.TestCase):
    def test_deepseek_platform_url_normalizes_to_api_base(self):
        self.assertEqual(
            server._normalize_api_url("https://platform.deepseek.com/api_keys"),
            "https://api.deepseek.com",
        )

    def test_deepseek_api_url_remains_api_base(self):
        self.assertEqual(
            server._normalize_api_url("api.deepseek.com"),
            "https://api.deepseek.com",
        )

    def test_deepseek_platform_endpoint_uses_official_api_host(self):
        self.assertEqual(
            server._endpoint_candidates("https://platform.deepseek.com", "chat/completions"),
            [
                "https://api.deepseek.com/v1/chat/completions",
                "https://api.deepseek.com/chat/completions",
            ],
        )

    def test_models_endpoint_prefers_v1_when_user_enters_api_root(self):
        self.assertEqual(
            server._endpoint_candidates("https://api.yudefu.top", "models"),
            [
                "https://api.yudefu.top/v1/models",
                "https://api.yudefu.top/models",
            ],
        )

    def test_models_endpoint_does_not_duplicate_v1(self):
        self.assertEqual(
            server._endpoint_candidates("https://api.yudefu.top/v1", "models"),
            ["https://api.yudefu.top/v1/models"],
        )

    def test_chat_endpoint_prefers_v1_when_user_enters_api_root(self):
        self.assertEqual(
            server._endpoint_candidates("https://api.yudefu.top/", "chat/completions"),
            [
                "https://api.yudefu.top/v1/chat/completions",
                "https://api.yudefu.top/chat/completions",
            ],
        )

    def test_patch_result_updates_prompt_and_preserves_original_fields(self):
        original = {
            "temperature": 0.8,
            "custom_field": {"keep": True},
            "prompts": [
                {
                    "identifier": "1",
                    "name": "基础提示",
                    "role": "system",
                    "content": "旧内容",
                    "system_prompt": False,
                }
            ],
            "prompt_order": [{"character_id": 100001, "order": [{"identifier": "1", "enabled": True}]}],
        }
        patch = {
            "sampling": {"temperature": 1.05},
            "prompt_updates": [{"identifier": "1", "content": "新内容"}],
        }

        enhanced = server._apply_ai_result(original, patch)

        self.assertEqual(enhanced["temperature"], 1.05)
        self.assertEqual(enhanced["custom_field"], {"keep": True})
        self.assertEqual(enhanced["prompts"][0]["content"], "新内容")
        self.assertEqual(original["prompts"][0]["content"], "旧内容")

    def test_patch_result_adds_prompt_and_prompt_order_entry(self):
        original = {
            "prompts": [
                {"identifier": "1", "name": "基础提示", "role": "system", "content": "旧内容"}
            ],
            "prompt_order": [{"character_id": 100001, "order": [{"identifier": "1", "enabled": True}]}],
        }
        patch = {
            "add_prompts": [
                {"name": "增强提示", "role": "system", "content": "新增内容", "enabled": True}
            ]
        }

        enhanced = server._apply_ai_result(original, patch)

        self.assertEqual(len(enhanced["prompts"]), 2)
        self.assertEqual(enhanced["prompts"][1]["identifier"], "2")
        self.assertEqual(enhanced["prompts"][1]["content"], "新增内容")
        self.assertEqual(
            enhanced["prompt_order"][0]["order"][-1],
            {"identifier": "2", "enabled": True},
        )


if __name__ == "__main__":
    unittest.main()
