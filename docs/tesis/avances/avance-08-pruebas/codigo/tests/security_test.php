<?php
// This file is part of Moodle - http://moodle.org/

namespace mod_aiassignment;

defined('MOODLE_INTERNAL') || die();

/**
 * Tests unitarios para la clase security (mejora #1).
 *
 * @package    mod_aiassignment
 * @category   test
 * @covers     \mod_aiassignment\security
 */
class security_test extends \advanced_testcase {

    public function test_sanitize_code_removes_null_bytes(): void {
        $code = "def hello():\0\n    print('hi')";
        $result = security::sanitize_code($code);
        $this->assertStringNotContainsString("\0", $result);
    }

    public function test_sanitize_code_normalizes_line_endings(): void {
        $code = "line1\r\nline2\rline3\nline4";
        $result = security::sanitize_code($code);
        $this->assertStringNotContainsString("\r", $result);
        $this->assertStringContainsString("\n", $result);
    }

    public function test_sanitize_code_rejects_empty(): void {
        $this->expectException(\moodle_exception::class);
        security::sanitize_code('');
    }

    public function test_sanitize_code_rejects_too_short(): void {
        $this->expectException(\moodle_exception::class);
        security::sanitize_code('ab');
    }

    public function test_sanitize_code_rejects_too_long(): void {
        $this->expectException(\moodle_exception::class);
        security::sanitize_code(str_repeat('a', 10001));
    }

    public function test_sanitize_code_blocks_xss_script_tag(): void {
        $this->expectException(\moodle_exception::class);
        security::sanitize_code('<script>alert("xss")</script>');
    }

    public function test_sanitize_code_blocks_javascript_protocol(): void {
        $this->expectException(\moodle_exception::class);
        security::sanitize_code('var x = "javascript: alert(1)";');
    }

    public function test_sanitize_code_allows_legitimate_code(): void {
        $code = "def fibonacci(n):\n    if n <= 1:\n        return n\n    return fibonacci(n-1) + fibonacci(n-2)";
        $result = security::sanitize_code($code);
        $this->assertStringContainsString('fibonacci', $result);
    }

    public function test_sanitize_code_allows_comparison_operators(): void {
        $code = "if (x < 10 && y > 5) { return true; }";
        $result = security::sanitize_code($code);
        $this->assertStringContainsString('<', $result);
        $this->assertStringContainsString('>', $result);
    }

    public function test_validate_api_key_format_openai(): void {
        $this->assertTrue(security::validate_api_key_format('sk-proj-abcdefghijklmnopqrstuvwxyz'));
        $this->assertFalse(security::validate_api_key_format(''));
        $this->assertFalse(security::validate_api_key_format('invalid'));
        $this->assertFalse(security::validate_api_key_format('pk-short'));
    }

    public function test_mask_api_key(): void {
        $key = 'sk-proj-abcdefghijklmnopqrstuvwxyz1234567890';
        $masked = security::mask_api_key($key);
        $this->assertStringStartsWith('sk-proj-', $masked);
        $this->assertStringContainsString('...', $masked);
        $this->assertEquals(4, strlen(substr($masked, strrpos($masked, '...') + 3)));
    }

    public function test_mask_api_key_short(): void {
        $masked = security::mask_api_key('short');
        $this->assertEquals('*****', $masked);
    }

    public function test_normalize_score(): void {
        $this->assertEquals(0.0, security::normalize_score(-10));
        $this->assertEquals(100.0, security::normalize_score(150));
        $this->assertEquals(75.55, security::normalize_score(75.554));
        $this->assertEquals(50.0, security::normalize_score(50));
    }

    public function test_generate_and_verify_action_token(): void {
        $this->resetAfterTest();
        $token = security::generate_action_token(42, 'reevaluate');
        $this->assertNotEmpty($token);
        $this->assertTrue(security::verify_action_token(42, 'reevaluate', $token));
        $this->assertFalse(security::verify_action_token(42, 'different_action', $token));
        $this->assertFalse(security::verify_action_token(99, 'reevaluate', $token));
    }
}
