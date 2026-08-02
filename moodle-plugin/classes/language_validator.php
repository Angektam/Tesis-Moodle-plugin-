<?php
// This file is part of Moodle - http://moodle.org/

namespace mod_aiassignment;

defined('MOODLE_INTERNAL') || die();

/**
 * Validador y detector de lenguaje de programación.
 *
 * Permite al maestro especificar qué lenguaje deben usar los estudiantes
 * en una tarea. Detecta el lenguaje del código entregado y bloquea
 * envíos en un lenguaje diferente al requerido.
 *
 * Lenguajes soportados:
 *   python | javascript | java | cpp | php | sql |
 *   typescript | ruby | go | rust | pseudocode
 */
class language_validator {

    /**
     * Mapa de señales de detección por lenguaje.
     * Cada entrada: [patrón_regex, peso]
     * Un lenguaje se considera detectado si acumula >= THRESHOLD puntos.
     */
    const THRESHOLD = 2;

    const SIGNALS = [
        'python' => [
            ['/\bdef\s+\w+\s*\(/m',             3],  // def funcion(
            ['/\belif\b/',                        2],  // elif (exclusivo de Python)
            ['/^from\s+\w+\s+import\s+/m',       2],  // from x import y
            ['/^import\s+\w/m',                   1],  // import x
            ['/\bprint\s*\(/m',                   1],  // print(
            ['/:$\s*\n\s+\S/m',                  2],  // bloque por indentación
            ['/\bNone\b|\bTrue\b|\bFalse\b/',    2],  // literales Python
            ['/\bself\b/',                        2],  // self (métodos Python)
            ['/\brange\s*\(/',                    1],  // range(
            ['/\blen\s*\(/',                      1],  // len(
        ],
        'javascript' => [
            ['/\bconsole\.log\s*\(/',             3],  // console.log(
            ['/\bconst\b|\blet\b/',               2],  // const / let
            ['/(=>)\s*[{(]/',                     2],  // arrow function
            ['/\bdocument\.\w+/',                 2],  // document.getElementById
            ['/\brequire\s*\(/',                  2],  // require(...)
            ['/\bfunction\s*\w*\s*\(/',           1],  // function
            ['/\bPromise\b|\basync\b|\bawait\b/', 2],  // async/await
            ['/\bmodule\.exports\b/',             2],  // CommonJS
        ],
        'typescript' => [
            ['/(=>)\s*[{(]/',                     1],  // arrow
            ['/:\s*(string|number|boolean|void|any|never|unknown)\b/', 3], // tipos TS
            ['/\binterface\s+\w+/',               3],  // interface
            ['/\benum\s+\w+/',                    3],  // enum
            ['/\bgeneric\b|<\w+>/',               2],  // genéricos
            ['/\bimport\s+.*from\s+[\'"]/',       2],  // import ES module
        ],
        'java' => [
            ['/\bpublic\s+class\s+\w+/',          3],  // public class
            ['/\bSystem\.out\.print/',             3],  // System.out.println
            ['/\bpublic\s+static\s+void\s+main/', 3],  // main method
            ['/\bimport\s+java\./',               3],  // import java.*
            ['/\bString\s+\w+\s*=/',              2],  // String var =
            ['/\bnew\s+\w+\s*\(/',               1],  // new Object()
            ['/\bthrows\s+\w+/',                  2],  // throws Exception
        ],
        'cpp' => [
            ['/#include\s*[<"]/',                 3],  // #include
            ['/\bint\s+main\s*\(/',               3],  // int main(
            ['/\bcout\s*<</',                     3],  // cout <<
            ['/\bcin\s*>>/',                      3],  // cin >>
            ['/\bstd::/',                         2],  // std::
            ['/\bmalloc\s*\(|\bfree\s*\(/',       2],  // malloc/free
            ['/\bprintf\s*\(/',                   2],  // printf
            ['/\bnullptr\b/',                     2],  // nullptr (C++11)
        ],
        'php' => [
            ['/<\?php/',                          3],  // <?php
            ['/\$\w+\s*=/',                       3],  // $variable =
            ['/\becho\s+/',                       2],  // echo
            ['/\barray\s*\(/',                    2],  // array(
            ['/\bfunction\s+\w+\s*\(/m',          1],  // function
            ['/->\w+/',                           2],  // ->property
            ['/\bnew\s+\w+\s*\(/',               1],  // new Class(
        ],
        'sql' => [
            ['/\bSELECT\b/i',                     3],  // SELECT
            ['/\bFROM\b/i',                       2],  // FROM
            ['/\bWHERE\b/i',                      1],  // WHERE
            ['/\bINSERT\s+INTO\b/i',              3],  // INSERT INTO
            ['/\bUPDATE\b.*\bSET\b/i',            3],  // UPDATE ... SET
            ['/\bDELETE\s+FROM\b/i',              3],  // DELETE FROM
            ['/\bJOIN\b/i',                       2],  // JOIN
            ['/\bCREATE\s+TABLE\b/i',             3],  // CREATE TABLE
            ['/\bGROUP\s+BY\b/i',                2],  // GROUP BY
        ],
        'ruby' => [
            ['/\bdef\s+\w+/m',                    2],  // def metodo
            ['/\bend\b/m',                        2],  // end (cierre bloques)
            ['/\bputs\s+/',                       3],  // puts (exclusivo Ruby)
            ['/\brequire\s+[\'"]/',               2],  // require 'gem'
            ['/\bdo\s*\|/',                       3],  // bloque do |var|
            ['/@\w+/',                            2],  // @instance_var
        ],
        'go' => [
            ['/\bfunc\s+\w+\s*\(/',               3],  // func nombre(
            ['/\bfmt\.Print/',                    3],  // fmt.Println
            ['/\bpackage\s+\w+/m',               3],  // package main
            ['/\bimport\s+"/',                    2],  // import "pkg"
            ['/:=/',                              3],  // := (exclusivo Go)
            ['/\bgoroutine\b|\bchan\b/',          3],  // goroutines/channels
        ],
        'rust' => [
            ['/\bfn\s+\w+\s*\(/',                 3],  // fn nombre(
            ['/\blet\s+mut\b/',                   3],  // let mut (exclusivo Rust)
            ['/\bprintln!\s*\(/',                 3],  // println! (macro)
            ['/\buse\s+std::/',                   3],  // use std::
            ['/\bimpl\s+\w+/',                    2],  // impl Struct
            ['/&mut\s+\w+/',                      2],  // borrowing mutable
        ],
    ];

    /**
     * Detecta el lenguaje de programación de un fragmento de código.
     *
     * @param  string $code Código fuente del estudiante
     * @return string       Clave del lenguaje detectado ('python', 'java', etc.)
     *                      o '' si no se puede determinar
     */
    public static function detect(string $code): string {
        if (empty(trim($code))) {
            return '';
        }

        $scores = [];
        foreach (self::SIGNALS as $lang => $patterns) {
            $score = 0;
            foreach ($patterns as [$pattern, $weight]) {
                if (preg_match($pattern, $code)) {
                    $score += $weight;
                }
            }
            if ($score >= self::THRESHOLD) {
                $scores[$lang] = $score;
            }
        }

        if (empty($scores)) {
            return '';
        }

        // Retornar el lenguaje con mayor puntuación
        arsort($scores);
        return array_key_first($scores);
    }

    /**
     * Verifica si el código coincide con el lenguaje requerido.
     *
     * @param  string $code             Código del estudiante
     * @param  string $required_lang    Lenguaje requerido por el maestro
     * @return array  ['valid' => bool, 'detected' => string, 'required' => string]
     */
    public static function validate(string $code, string $required_lang): array {
        if (empty($required_lang)) {
            return ['valid' => true, 'detected' => '', 'required' => ''];
        }

        $detected = self::detect($code);

        // Si no se detectó nada concreto, se da el beneficio de la duda
        if (empty($detected)) {
            return ['valid' => true, 'detected' => '', 'required' => $required_lang];
        }

        return [
            'valid'    => ($detected === $required_lang),
            'detected' => $detected,
            'required' => $required_lang,
        ];
    }

    /**
     * Devuelve la etiqueta legible de un lenguaje.
     *
     * @param  string $lang  Clave del lenguaje
     * @return string        Etiqueta con emoji
     */
    public static function label(string $lang): string {
        $labels = [
            'python'     => '🐍 Python',
            'javascript' => '🟨 JavaScript',
            'typescript' => '🔷 TypeScript',
            'java'       => '☕ Java',
            'cpp'        => '⚙️ C/C++',
            'php'        => '🐘 PHP',
            'sql'        => '🗄️ SQL',
            'ruby'       => '💎 Ruby',
            'go'         => '🐹 Go',
            'rust'       => '🦀 Rust',
            'pseudocode' => '📋 Pseudocódigo',
        ];
        return $labels[$lang] ?? $lang;
    }

    /**
     * Lista todos los lenguajes disponibles para el formulario del maestro.
     *
     * @return array [clave => etiqueta]
     */
    public static function get_options(): array {
        $options = ['' => get_string('lang_any', 'aiassignment')];
        foreach (array_keys(self::SIGNALS) as $lang) {
            $options[$lang] = self::label($lang);
        }
        $options['pseudocode'] = self::label('pseudocode');
        return $options;
    }
}
