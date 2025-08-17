Class {
	#name : #GtLlmLepiterContentExporterExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-GToolkit-Examples'
}

{ #category : #'llm-generated' }
GtLlmLepiterContentExporterExamples >> exportingAPage [
	<gtExample>
	| page text pharo exporter result |
	page := LePage new title: 'My Page'; yourself.
	text := LeTextSnippet new string: 'Hello'; yourself.
	pharo := LePharoSnippet new code: '1 + 2'; yourself.
	page addSnippet: text.
	page addSnippet: pharo.
	exporter := GtLlmLepiterContentExporter new.
	exporter page: page.
	result := exporter export.
	self assert: (result includesSubstring: '# My Page').
	self assert: (result includesSubstring: 'Hello').
	self assert: (result includesSubstring: '```pharo').
	self assert: (result includesSubstring: '1 + 2').
	^ page
]

{ #category : #'llm-generated' }
GtLlmLepiterContentExporterExamples >> exportingTheChildrenOfPage [
	<gtExample>
	| page text pharo exporter result |
	page := LePage new title: 'My Page'; yourself.
	text := LeTextSnippet new string: 'Hello'; yourself.
	pharo := LePharoSnippet new code: '1 + 2'; yourself.
	page addSnippet: text.
	page addSnippet: pharo.
	exporter := GtLlmLepiterContentExporter new.
	exporter childrenOf: page.
	result := exporter export.
	self assert: (result includesSubstring: '# My Page') not.
	self assert: (result includesSubstring: 'Hello').
	self assert: (result includesSubstring: '```pharo').
	self assert: (result includesSubstring: '1 + 2').
	^ page
]
