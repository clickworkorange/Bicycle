require "kramdown/parser/gfm"

module Kramdown
  module Parser

    # This class provides a "comment safe" subset of the GFM dialect of Markdown.
    class Comment < Kramdown::Parser::GFM
      
      REMOVE_BLOCK = [:codeblock, :atx_header, :horizontal_rule, :definition_list, :block_html, :setext_header, :block_math, :footnote_definition, :link_definition, :abbrev_definition, :block_extensions, :eob_marker]
      REMOVE_INLINE = [:autolink, :footnote_marker, :span_extensions, :inline_math, :typographic_syms]
      # Remaining block parsers: [:blank_line, :codeblock_fenced, :blockquote, :list, :table, :paragraph]
      # Remaining span parsers: [:emphasis, :codespan, :span_html, :link, :smart_quotes, :html_entity, :line_break, :escaped_chars]

      def initialize(source, options) # :nodoc:
        super
        @block_parsers.delete_if {|i| REMOVE_BLOCK.include?(i) }
        @span_parsers.delete_if {|i| REMOVE_INLINE.include?(i) }
      end
    end
  end
end