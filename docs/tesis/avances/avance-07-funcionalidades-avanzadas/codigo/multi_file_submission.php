<?php
// This file is part of Moodle - http://moodle.org/

namespace mod_aiassignment;

defined('MOODLE_INTERNAL') || die();

/**
 * Soporte para envíos de múltiples archivos.
 * Los archivos se almacenan en el file storage de Moodle y se
 * concatenan para evaluación IA manteniendo separadores de archivo.
 */
class multi_file_submission {

    const FILEAREA   = 'submission_files';
    const MAX_FILES  = 10;
    const MAX_SIZE   = 2097152; // 2 MB por archivo
    const ALLOWED_EXT = ['py', 'js', 'ts', 'java', 'c', 'cpp', 'h', 'php',
                          'rb', 'go', 'rs', 'cs', 'txt', 'md', 'sql', 'html', 'css'];

    /**
     * Procesa archivos subidos y los adjunta a un envío.
     * Devuelve el código concatenado para evaluación.
     *
     * @param int    $submissionid
     * @param int    $draftitemid  ID del draft area de Moodle
     * @param object $context
     * @return string Código concatenado de todos los archivos
     */
    public static function process_files(int $submissionid, int $draftitemid, $context): string {
        $fs = get_file_storage();

        // Mover archivos del draft al área permanente
        file_save_draft_area_files(
            $draftitemid,
            $context->id,
            'mod_aiassignment',
            self::FILEAREA,
            $submissionid,
            ['subdirs' => 0, 'maxfiles' => self::MAX_FILES, 'maxbytes' => self::MAX_SIZE]
        );

        return self::get_concatenated_code($submissionid, $context);
    }

    /**
     * Obtiene el código concatenado de todos los archivos de un envío.
     */
    public static function get_concatenated_code(int $submissionid, $context): string {
        $fs    = get_file_storage();
        $files = $fs->get_area_files(
            $context->id, 'mod_aiassignment', self::FILEAREA,
            $submissionid, 'filename', false
        );

        if (empty($files)) return '';

        $parts = [];
        foreach ($files as $file) {
            $ext = strtolower(pathinfo($file->get_filename(), PATHINFO_EXTENSION));
            if (!in_array($ext, self::ALLOWED_EXT)) continue;

            $content = $file->get_content();
            $parts[] = "// ── Archivo: " . $file->get_filename() . " ──\n" . $content;
        }

        return implode("\n\n", $parts);
    }

    /**
     * Lista los archivos de un envío con metadatos.
     */
    public static function list_files(int $submissionid, $context): array {
        $fs    = get_file_storage();
        $files = $fs->get_area_files(
            $context->id, 'mod_aiassignment', self::FILEAREA,
            $submissionid, 'filename', false
        );

        $result = [];
        foreach ($files as $file) {
            $result[] = [
                'name'     => $file->get_filename(),
                'size'     => $file->get_filesize(),
                'mimetype' => $file->get_mimetype(),
                'url'      => \moodle_url::make_pluginfile_url(
                    $context->id, 'mod_aiassignment', self::FILEAREA,
                    $submissionid, '/', $file->get_filename()
                )->out(),
            ];
        }
        return $result;
    }

    /**
     * Elimina todos los archivos de un envío.
     */
    public static function delete_files(int $submissionid, $context): void {
        $fs = get_file_storage();
        $fs->delete_area_files(
            $context->id, 'mod_aiassignment', self::FILEAREA, $submissionid
        );
    }

    /**
     * Renderiza el widget de subida de archivos para view.php.
     */
    public static function render_upload_widget(int $cmid, string $sesskey): string {
        $exts = implode(', .', self::ALLOWED_EXT);
        $html  = '<div class="multi-file-upload" style="margin-bottom:12px;">';
        $html .= '<div style="display:flex;align-items:center;gap:10px;margin-bottom:8px;">';
        $html .= '<label style="font-size:13px;font-weight:600;color:#555;">📎 Archivos adicionales (opcional)</label>';
        $html .= '<span style="font-size:11px;color:#888;">Máx. ' . self::MAX_FILES . ' archivos · 2MB c/u · .' . $exts . '</span>';
        $html .= '</div>';
        $html .= '<div id="file-drop-zone" style="border:2px dashed #dee2e6;border-radius:8px;padding:20px;text-align:center;cursor:pointer;transition:border-color .2s;background:#fafafa;">';
        $html .= '<div id="drop-text" style="color:#888;font-size:13px;">🗂️ Arrastra archivos aquí o <span style="color:#1a73e8;text-decoration:underline;cursor:pointer;" onclick="document.getElementById(\'file-input\').click()">selecciona</span></div>';
        $html .= '<input type="file" id="file-input" name="submission_files[]" multiple accept=".' . implode(',.', self::ALLOWED_EXT) . '" style="display:none;">';
        $html .= '<div id="file-list" style="margin-top:10px;text-align:left;"></div>';
        $html .= '</div>';
        $html .= '</div>';

        $html .= '<script>
(function() {
    var zone  = document.getElementById("file-drop-zone");
    var input = document.getElementById("file-input");
    var list  = document.getElementById("file-list");
    var files = [];

    zone.addEventListener("dragover",  function(e) { e.preventDefault(); zone.style.borderColor="#1a73e8"; });
    zone.addEventListener("dragleave", function()  { zone.style.borderColor="#dee2e6"; });
    zone.addEventListener("drop", function(e) {
        e.preventDefault();
        zone.style.borderColor="#dee2e6";
        addFiles(e.dataTransfer.files);
    });
    input.addEventListener("change", function() { addFiles(this.files); });

    function addFiles(newFiles) {
        for (var i = 0; i < newFiles.length; i++) {
            if (files.length >= ' . self::MAX_FILES . ') break;
            files.push(newFiles[i]);
        }
        renderList();
    }

    function renderList() {
        list.innerHTML = "";
        files.forEach(function(f, idx) {
            var div = document.createElement("div");
            div.style.cssText = "display:flex;align-items:center;gap:8px;padding:4px 0;font-size:12px;border-bottom:1px solid #f0f0f0;";
            div.innerHTML = "📄 <strong>" + f.name + "</strong> <span style=\'color:#888;\'>(" + (f.size/1024).toFixed(1) + " KB)</span>" +
                "<button type=\'button\' onclick=\'removeFile(" + idx + ")\' style=\'margin-left:auto;background:none;border:none;color:#dc3545;cursor:pointer;font-size:14px;\'>✕</button>";
            list.appendChild(div);
        });
        // Actualizar el input con los archivos seleccionados
        var dt = new DataTransfer();
        files.forEach(function(f) { dt.items.add(f); });
        input.files = dt.files;
    }

    window.removeFile = function(idx) {
        files.splice(idx, 1);
        renderList();
    };
})();
</script>';

        return $html;
    }
}
