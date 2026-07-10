require "./spec_helper"

# Auto-generated query validation — ported from syntastica's `queries_test!()` macro.
# Ensures every language's queries compile correctly against its grammar.

describe "Query validation against grammars" do
  # Only test languages that have queries AND where the grammar is cached
  langs_with_queries = TreeSitterManager::QueryManager.available_languages("queries")

  langs_with_queries.sort.each do |lang|
    it "validates queries compile for #{lang}" do
      # Check if grammar is available (skip if not installed)
      libpath = TreeSitterManager::GrammarLoader.find_grammar_library(lang)
      next unless libpath

      language = TreeSitterManager::GrammarLoader.load_language(lang)
      next unless language

      # Load queries
      queries = TreeSitterManager::QueryManager.load_queries(lang, "queries")

      # Validate highlights query
      unless queries.highlights.empty?
        highlight_query = begin
          TreeSitter::Query.new(language, queries.highlights)
        rescue ex : TreeSitter::Error
          fail "highlights query for #{lang} failed: #{ex.message}"
        end
        highlight_query.should be_a(TreeSitter::Query)
      end

      # Validate injections query
      unless queries.injections.empty?
        injection_query = begin
          TreeSitter::Query.new(language, queries.injections)
        rescue ex : TreeSitter::Error
          fail "injections query for #{lang} failed: #{ex.message}"
        end
        injection_query.should be_a(TreeSitter::Query)
      end

      # Validate locals query
      unless queries.locals.empty?
        locals_query = begin
          TreeSitter::Query.new(language, queries.locals)
        rescue ex : TreeSitter::Error
          fail "locals query for #{lang} failed: #{ex.message}"
        end
        locals_query.should be_a(TreeSitter::Query)
      end
    end
  end
end
