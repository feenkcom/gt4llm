Class {
	#name : #GtLlmTextSnippetExporter,
	#superclass : #Object,
	#instVars : [
		'stream',
		'startHeaderLevel'
	],
	#category : #'Gt4Llm-GToolkit-Exporter'
}

{ #category : #'as yet unclassified' }
GtLlmTextSnippetExporter >> exportAst: anAst [
	stream := WriteStream on: ''.
	self visit: anAst.
	^ stream contents
]

{ #category : #private }
GtLlmTextSnippetExporter >> fileReferenceDirectoryListingFor: aFileReference [
	^ String streamContents: [ :stream |
		(aFileReference children
			asSortedCollection: [ :a :b | a basename <= b basename ])
			do: [ :each | stream nextPutAll: each basename; lf ] ]
]

{ #category : #private }
GtLlmTextSnippetExporter >> fileReferenceExportStringFor: aLeFileReference [
	^ aLeFileReference fileReference isDirectory
		ifTrue: [ self fileReferenceDirectoryListingFor: aLeFileReference fileReference ]
		ifFalse: [ self fileReferenceFileContentsFor: aLeFileReference ]
]

{ #category : #private }
GtLlmTextSnippetExporter >> fileReferenceFileContentsFor: aLeFileReference [
	| contents interval lines start end |
	contents := aLeFileReference fileReference contents.
	interval := aLeFileReference range.
	interval ifNil: [ ^ contents ].
	lines := contents lines.
	start := interval first max: 1.
	end := interval last min: lines size.
	start > end ifTrue: [ ^ '' ].
	^ String streamContents: [ :stream |
		(lines copyFrom: start to: end)
			do: [ :line | stream nextPutAll: line; lf ] ]
]

{ #category : #'as yet unclassified' }
GtLlmTextSnippetExporter >> initialize [
	super initialize.
	startHeaderLevel := 0
]

{ #category : #accessing }
GtLlmTextSnippetExporter >> startHeaderLevel [
	^ startHeaderLevel
]

{ #category : #accessing }
GtLlmTextSnippetExporter >> startHeaderLevel: anObject [
	startHeaderLevel := anObject
]

{ #category : #'as yet unclassified' }
GtLlmTextSnippetExporter >> visit: anAst [
	^ anAst acceptVisitor: self
]

{ #category : #'as yet unclassified' }
GtLlmTextSnippetExporter >> visitBold: aLeBoldNode [ 
	stream nextPutAll: aLeBoldNode source
]

{ #category : #'as yet unclassified' }
GtLlmTextSnippetExporter >> visitClassAnnotation: aLeClassAnnotationNode [
	aLeClassAnnotationNode expanded
		ifTrue: [ | aClass |
			aClass := aLeClassAnnotationNode nameNode imageObject.
			aClass
				ifNil: [ stream nextPutAll: aLeClassAnnotationNode parent source ]
				ifNotNil: [ stream
						nextPutAll: '

```smalltalk
' , aClass definitionString
								, '
```

' ] ]
		ifFalse: [ stream nextPutAll: aLeClassAnnotationNode parent source ]
]

{ #category : #'as yet unclassified' }
GtLlmTextSnippetExporter >> visitCodeBlock: aLeCodeBlockNode [
	stream nextPutAll: aLeCodeBlockNode source
]

{ #category : #'as yet unclassified' }
GtLlmTextSnippetExporter >> visitDocumenterAnnotation: aLeDocumenterAnnotationNode [
	self visit: aLeDocumenterAnnotationNode annotation
]

{ #category : #'as yet unclassified' }
GtLlmTextSnippetExporter >> visitDoubleBracketLink: aLeDoubleBracketLinkNode [ 
	stream nextPutAll: aLeDoubleBracketLinkNode source
]

{ #category : #'as yet unclassified' }
GtLlmTextSnippetExporter >> visitExampleAnnotation: aLeExampleAnnotationNode [
	self visitMethodAnnotation: aLeExampleAnnotationNode
]

{ #category : #'as yet unclassified' }
GtLlmTextSnippetExporter >> visitExternalLabelUrlLink: aLeExternalLabelUrlLinkNode [ 
	stream nextPutAll: aLeExternalLabelUrlLinkNode source
]

{ #category : #'as yet unclassified' }
GtLlmTextSnippetExporter >> visitExternalUrlLink: aLeExternalUrlLinkNode [ 
	stream nextPutAll: aLeExternalUrlLinkNode source
]

{ #category : #visiting }
GtLlmTextSnippetExporter >> visitFileReferenceAnnotation: aLeFileReferenceAnnotationNode [
	| isExpanded fileReference contents |
	isExpanded := aLeFileReferenceAnnotationNode expandedValue ifNil: [ false ].
	isExpanded ifFalse: [ ^ stream nextPutAll: aLeFileReferenceAnnotationNode parent source ].

	fileReference := LeFileReference
		fromAnnotation: aLeFileReferenceAnnotationNode
		inPage: nil.
	(fileReference isNil or: [ fileReference fileReference exists not ])
		ifTrue: [ ^ stream nextPutAll: aLeFileReferenceAnnotationNode parent source ].

	contents := self fileReferenceExportStringFor: fileReference.
	stream
		nextPutAll: String cr;
		nextPutAll: String cr;
		nextPutAll: '```file-reference';
		nextPutAll: String cr;
		nextPutAll: contents;
		nextPutAll: '```';
		nextPutAll: String cr;
		nextPutAll: String cr
]

{ #category : #'as yet unclassified' }
GtLlmTextSnippetExporter >> visitHeader: aLeHeaderNode [
	stream
		nextPutAll: ('#' repeat: aLeHeaderNode numberSigns size + startHeaderLevel);
		space;
		nextPutAll: aLeHeaderNode headerName asString trim
]

{ #category : #'as yet unclassified' }
GtLlmTextSnippetExporter >> visitInlineCode: aLeInlineCodeNode [ 
	stream nextPutAll: aLeInlineCodeNode source
]

{ #category : #'as yet unclassified' }
GtLlmTextSnippetExporter >> visitItalic: aLeItalicNode [ 
	stream nextPutAll: aLeItalicNode source
]

{ #category : #'as yet unclassified' }
GtLlmTextSnippetExporter >> visitMethodAnnotation: aLeMethodAnnotationNode [
	aLeMethodAnnotationNode expanded
		ifTrue: [ | aClass |
			aClass := aLeMethodAnnotationNode nameNode imageObject.
			aClass
				ifNil: [ stream nextPutAll: aLeMethodAnnotationNode parent source ]
				ifNotNil: [ stream
						nextPutAll: '

```smalltalk-method
' , aClass methodClass asString , '>>' , aClass sourceCode
								, '
```

' ] ]
		ifFalse: [ stream nextPutAll: aLeMethodAnnotationNode parent source ]
]

{ #category : #'as yet unclassified' }
GtLlmTextSnippetExporter >> visitPackageAnnotation: aLePackageAnnotationNode [
	stream nextPutAll: aLePackageAnnotationNode parent source
]

{ #category : #'as yet unclassified' }
GtLlmTextSnippetExporter >> visitPageAnnotation: aLePageAnnotationNode [
	stream nextPutAll: aLePageAnnotationNode parent source
]

{ #category : #'as yet unclassified' }
GtLlmTextSnippetExporter >> visitString: aLeStringNode [
	aLeStringNode parts do: [ :aPart | aPart acceptVisitor: self ]
]

{ #category : #'as yet unclassified' }
GtLlmTextSnippetExporter >> visitText: aLeTextNode [ 
	stream nextPutAll: aLeTextNode content
]

{ #category : #'as yet unclassified' }
GtLlmTextSnippetExporter >> visitTodoAnnotation: aLeTodoAnnotationNode [
	stream nextPutAll: aLeTodoAnnotationNode parent source
]

{ #category : #'as yet unclassified' }
GtLlmTextSnippetExporter >> visitWordAnnotation: aLeWordAnnotationNode [ 
	stream nextPutAll: aLeWordAnnotationNode parent source
]
