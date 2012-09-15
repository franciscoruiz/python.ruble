require 'ruble'


def get_annotations_in_current_line(editor)
  current_line_no = editor.caret_line + 1  # Make it 1-based
  Ruble::Logger.trace "Annotations in current line (%d)" % current_line_no.to_s
  
  doc = editor.document
  
  annotations = []
  source_viewer = editor.editor_part.source_viewer
  model = source_viewer.annotation_model
  iter = model.annotation_iterator
  while iter.hasNext()
    annotation = iter.next
    position = model.getPosition(annotation)
    annotation_line = doc.line_of_offset(position.offset)
    if annotation_line == editor.caret_line
      Ruble::Logger.trace annotation.text
      annotations << annotation
    end
  end
  
  return annotations
end


def get_pylint_problem_ids_in_current_line(editor)
  pylint_problem_ids = []
  
  annotations = get_annotations_in_current_line(editor)
  annotations.each do |annotation|
    annotation_text = annotation.text
    match = annotation_text.match(/ID:(\w{5})/)
    if match
      pylint_problem_ids << match[1]
    end
  end
  
  return pylint_problem_ids
end


command t(:silence_pylint_problems_in_current_line) do |cmd|
  cmd.input = :line
  cmd.output = :replace_line
  cmd.key_binding = 'M1+P'
  cmd.invoke do |context|
    Ruble::Logger.trace "Locally disabling Pylint problems in current line"
    
    pylint_problem_ids = get_pylint_problem_ids_in_current_line(context.editor)
    
    current_line = $stdin.read
    if pylint_problem_ids.empty?
      print current_line
    else
      printf(
        "%s  # pylint: disable=%s",
        current_line,
        pylint_problem_ids.join(',')
        )
    end
  end
end