"
Executable examples of exporting Lepiter text snippets to Markdown, including tables and preserved or expanded annotations.
"
Class {
	#name : #GtLTextSnippetExporterExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #'examples - annotations' }
GtLTextSnippetExporterExamples >> annotationsWithLabels [
	<gtExample>
	| text result |
	text := 'Use {{gtClass:Point|label=point}} and {{gtMethod:Point>>#x|label=coordinate}}.'.
	result := self export: text.
	self assert: result equals: text.
	^ result
]

{ #category : #'examples - text' }
GtLTextSnippetExporterExamples >> basicText [
	<gtExample>
	| text result |
	text := 'Hello, world! A plain text snippet.'.
	result := self export: text.
	self assert: result equals: text.
	^ result
]

{ #category : #'examples - annotations' }
GtLTextSnippetExporterExamples >> classAnnotation [
	<gtExample>
	| text result |
	text := 'See {{gtClass:Point}} for coordinates.'.
	result := self export: text.
	self assert: result equals: text.
	^ result
]

{ #category : #'examples - text' }
GtLTextSnippetExporterExamples >> emptyText [
	<gtExample>
	| result |
	result := self export: ''.
	self assert: result equals: ''.
	^ result
]

{ #category : #'examples - annotations' }
GtLTextSnippetExporterExamples >> expandedClassAnnotation [
	<gtExample>
	| result expected |
	result := self export: '{{gtClass:Point|expanded}}'.
	expected := String cr , String cr , '```smalltalk' , String cr
		, Point definitionString , String cr , '```' , String cr , String cr.
	self assert: result equals: expected.
	^ result
]

{ #category : #'examples - annotations' }
GtLTextSnippetExporterExamples >> expandedMethodAnnotation [
	<gtExample>
	| result expected method |
	method := Point >> #x.
	result := self export: '{{gtMethod:Point>>#x|expanded}}'.
	expected := String cr , String cr , '```smalltalk-method' , String cr
		, method methodClass asString , '>>' , method sourceCode
		, String cr , '```' , String cr , String cr.
	self assert: result equals: expected.
	^ result
]

{ #category : #private }
GtLTextSnippetExporterExamples >> export: aString [
	^ GtLTextSnippetExporter new exportAst: (LeTextSnippet string: aString) ast
]

{ #category : #'examples - text' }
GtLTextSnippetExporterExamples >> formattedText [
	<gtExample>
	| text result |
	text := 'Text with **bold**, *italic*, and `Point new` inline code.'.
	result := self export: text.
	self assert: result equals: text.
	^ result
]

{ #category : #'examples - tables' }
GtLTextSnippetExporterExamples >> markdownTable [
	<gtExample>
	| text result |
	text := String lf join: #('| Name | Value |' '| --- | --- |' '| One | 1 |' '| Two | 2 |').
	result := self export: text.
	self assert: result equals: text.
	^ result
]

{ #category : #'examples - annotations' }
GtLTextSnippetExporterExamples >> markdownTableWithAnnotations [
	<gtExample>
	| text result |
	text := String lf join: #('| Kind | Reference |' '| --- | --- |' '| Class | {{gtClass:Point}} |' '| Method | {{gtMethod:Point>>#x}} |').
	result := self export: text.
	self assert: result equals: text.
	^ result
]

{ #category : #'examples - tables' }
GtLTextSnippetExporterExamples >> markdownTableWithFormatting [
	<gtExample>
	| text result |
	text := String lf join: #('| Name | Value |' '| :--- | ---: |' '| **One** | `1` |' '| *Two* | 2 |').
	result := self export: text.
	self assert: result equals: text.
	^ result
]

{ #category : #'examples - annotations' }
GtLTextSnippetExporterExamples >> methodAnnotation [
	<gtExample>
	| text result |
	text := 'See {{gtMethod:Point>>#x}} for the coordinate.'.
	result := self export: text.
	self assert: result equals: text.
	^ result
]

{ #category : #'examples - text' }
GtLTextSnippetExporterExamples >> multilineText [
	<gtExample>
	| text result |
	text := 'First line.' , String lf , String lf , 'Second paragraph with Unicode: café λ.'.
	result := self export: text.
	self assert: result equals: text.
	^ result
]

{ #category : #'examples - annotations' }
GtLTextSnippetExporterExamples >> unresolvedExpandedClassAnnotation [
	<gtExample>
	| text result |
	text := '{{gtClass:GtLTextSnippetExporterNonexistentClassForExample|expanded}}'.
	self assert: (Smalltalk globals includesKey: #GtLTextSnippetExporterNonexistentClassForExample) not.
	result := self export: text.
	self assert: result equals: text.
	^ result
]

{ #category : #'examples - annotations' }
GtLTextSnippetExporterExamples >> unresolvedExpandedMethodAnnotation [
	<gtExample>
	| text result |
	text := '{{gtMethod:Point>>#gtLNonexistentSelectorForExporterExample|expanded}}'.
	self assert: (Point canUnderstand: #gtLNonexistentSelectorForExporterExample) not.
	result := self export: text.
	self assert: result equals: text.
	^ result
]
