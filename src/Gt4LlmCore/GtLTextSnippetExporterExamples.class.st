"
Executable examples of exporting Lepiter text snippets to Markdown, including tables and preserved or expanded annotations.
"
Class {
	#name : #GtLTextSnippetExporterExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #'examples - annotations' }
GtLTextSnippetExporterExamples >> allAnnotationsKeepTheirSource [
	"Every annotation that is not expanded is exported as it was written, whether or not the exporter knows it"

	<gtExample>
	<return: #Array>
	^ self annotationSamples
		collect: [ :each | 
			| text result |
			text := 'Before ' , each value , ' after'.
			result := self export: text.
			self
				assert: result = text
				description: [ each key , ' must be exported as it was written, got: ' , result ].
			each key -> result ]

]

{ #category : #private }
GtLTextSnippetExporterExamples >> annotationSamples [
	"One sample of every annotation registered in LeParser class>>#annotationParsers (core and extension packages)"

	^ {'gtClass' -> '{{gtClass:Point}}'.
		'gtPackage' -> '{{gtPackage:Lepiter-Core}}'.
		'gtMethod' -> '{{gtMethod:Point>>#x}}'.
		'gtChanges' -> '{{gtChanges:directory/filename 1.ombu|height=400}}'.
		'gtExample' -> '{{gtExample:GtLTextSnippetExporterExamples>>#basicText|noCode}}'.
		'gtPage' -> '{{gtPage:Some missing page title}}'.
		'gtTodo' -> '{{gtTodo:label=Write more examples|completed=2023-03-04}}'.
		'gtSymbol' -> '{{gtSymbol:asString}}'.
		'gtWordExplanation' -> '{{gtWordExplanation:toolkit|expanded}}'.
		'gtPragma' -> '{{gtPragma:gtView|expanded}}'.
		'gtPictureReference' -> '{{gtPictureReference:picture3}}'.
		'gtFileReference' -> '{{gtFileReference:path=gtoolkit.yaml|label="Yaml"}}'.
		'gtObject' -> '{{gtObject:id=eehjmwhvkh4de3o55fyirb3fo|label=#gtDisplayString}}'}

]

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
GtLTextSnippetExporterExamples >> changesAnnotation [
	<gtExample>
	<return: #ByteString>
	| text result |
	text := 'See {{gtChanges:directory/filename 1.ombu|height=400}} here'.
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

{ #category : #'examples - annotations' }
GtLTextSnippetExporterExamples >> headerWithSymbolAnnotation [
	<gtExample>
	<return: #ByteString>
	| result |
	result := self export: '# Header {{gtSymbol:asString}}'.
	self assert: result equals: '# Header {{gtSymbol:asString}}'.
	^ result

]

{ #category : #'examples - annotations' }
GtLTextSnippetExporterExamples >> malformedAnnotationKeepsSource [
	<gtExample>
	<return: #ByteString>
	| text result |
	text := 'a {{gtClass:}} b {{gtMethod:Point>>}} c'.
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
GtLTextSnippetExporterExamples >> objectAnnotation [
	"The object id stays in the export, so a reader can resolve it with the object storage tools"

	<gtExample>
	<return: #ByteString>
	| text result |
	text := 'See {{gtObject:id=eehjmwhvkh4de3o55fyirb3fo|label=#gtDisplayString}} here'.
	result := self export: text.
	self assert: result equals: text.
	^ result

]

{ #category : #'examples - pages' }
GtLTextSnippetExporterExamples >> pageWithExtensionAnnotations [
	"The strict content exporter does not fail on a page with extension annotations"

	<gtExample>
	<return: #ByteString>
	| aPage result |
	aPage := LePage named: 'Extension annotations'.
	aPage
		addSnippet: (LeTextSnippet
				string: 'Override {{gtSymbol:handleCompletedTest}}, see {{gtPictureReference:picture3}}.').
	aPage
		addSnippet: (LeTextSnippet
				string: 'Unknown {{gtFoo:bar}} and {{gtObject:id=eehjmwhvkh4de3o55fyirb3fo}}.').

	result := GtLLepiterContentExporter new
			page: aPage;
			export.

	self assert: (result includesSubstring: '{{gtSymbol:handleCompletedTest}}').
	self assert: (result includesSubstring: '{{gtPictureReference:picture3}}').
	self assert: (result includesSubstring: '{{gtFoo:bar}}').
	self assert: (result includesSubstring: '{{gtObject:id=eehjmwhvkh4de3o55fyirb3fo}}').
	^ result

]

{ #category : #'examples - annotations' }
GtLTextSnippetExporterExamples >> pictureAnnotation [
	<gtExample>
	<return: #ByteString>
	| text result |
	text := 'See {{gtPictureReference:picture3}} here'.
	result := self export: text.
	self assert: result equals: text.
	^ result

]

{ #category : #'examples - annotations' }
GtLTextSnippetExporterExamples >> symbolAnnotation [
	<gtExample>
	<return: #ByteString>
	| text result |
	text := 'Uses {{gtSymbol:handleCompletedTest}} and {{gtSymbol:cleanUpAfterTest}}.'.
	result := self export: text.
	self assert: result equals: text.
	^ result

]

{ #category : #'examples - annotations' }
GtLTextSnippetExporterExamples >> unknownAnnotationKeepsSource [
	<gtExample>
	<return: #ByteString>
	| text result |
	text := 'a {{gtFoo:bar}} b'.
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

{ #category : #'examples - annotations' }
GtLTextSnippetExporterExamples >> unterminatedAnnotationKeepsSource [
	"Without its closing braces the annotation is not parsed as an annotation, the parser answers an error node for the rest of the text"

	<gtExample>
	<return: #ByteString>
	| text result |
	text := 'a {{gtClass:Point and more text'.
	result := self export: text.
	self assert: result equals: text.
	^ result

]
