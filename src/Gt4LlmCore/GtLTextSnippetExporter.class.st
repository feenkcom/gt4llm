Class {
	#name : #GtLTextSnippetExporter,
	#superclass : #Object,
	#instVars : [
		'stream',
		'startHeaderLevel'
	],
	#category : #'Gt4LlmCore-Exporter'
}

{ #category : #'as yet unclassified' }
GtLTextSnippetExporter >> exportAst: anAst [
	stream := WriteStream on: ''.
	self visit: anAst.
	^ stream contents
]

{ #category : #private }
GtLTextSnippetExporter >> fileReferenceDirectoryListingFor: aFileReference [
	^ String streamContents: [ :stream |
		(aFileReference children
			asSortedCollection: [ :a :b | a basename <= b basename ])
			do: [ :each | stream nextPutAll: each basename; lf ] ]
]

{ #category : #private }
GtLTextSnippetExporter >> fileReferenceExportStringFor: aLeFileReference [
	^ aLeFileReference fileReference isDirectory
		ifTrue: [ self fileReferenceDirectoryListingFor: aLeFileReference fileReference ]
		ifFalse: [ self fileReferenceFileContentsFor: aLeFileReference ]
]

{ #category : #private }
GtLTextSnippetExporter >> fileReferenceFileContentsFor: aLeFileReference [
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
GtLTextSnippetExporter >> initialize [
	super initialize.
	startHeaderLevel := 0
]

{ #category : #accessing }
GtLTextSnippetExporter >> startHeaderLevel [
	^ startHeaderLevel
]

{ #category : #accessing }
GtLTextSnippetExporter >> startHeaderLevel: anObject [
	startHeaderLevel := anObject
]

{ #category : #'as yet unclassified' }
GtLTextSnippetExporter >> visit: anAst [
	^ anAst acceptVisitor: self
]

{ #category : #'as yet unclassified' }
GtLTextSnippetExporter >> visitBold: aLeBoldNode [ 
	stream nextPutAll: aLeBoldNode source
]

{ #category : #'as yet unclassified' }
GtLTextSnippetExporter >> visitClassAnnotation: aLeClassAnnotationNode [
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
GtLTextSnippetExporter >> visitCodeBlock: aLeCodeBlockNode [
	stream nextPutAll: aLeCodeBlockNode source
]

{ #category : #'as yet unclassified' }
GtLTextSnippetExporter >> visitDocumenterAnnotation: aLeDocumenterAnnotationNode [
	self visit: aLeDocumenterAnnotationNode annotation
]

{ #category : #'as yet unclassified' }
GtLTextSnippetExporter >> visitDoubleBracketLink: aLeDoubleBracketLinkNode [ 
	stream nextPutAll: aLeDoubleBracketLinkNode source
]

{ #category : #'as yet unclassified' }
GtLTextSnippetExporter >> visitExampleAnnotation: aLeExampleAnnotationNode [
	self visitMethodAnnotation: aLeExampleAnnotationNode
]

{ #category : #'as yet unclassified' }
GtLTextSnippetExporter >> visitExternalLabelUrlLink: aLeExternalLabelUrlLinkNode [ 
	stream nextPutAll: aLeExternalLabelUrlLinkNode source
]

{ #category : #'as yet unclassified' }
GtLTextSnippetExporter >> visitExternalUrlLink: aLeExternalUrlLinkNode [ 
	stream nextPutAll: aLeExternalUrlLinkNode source
]

{ #category : #visiting }
GtLTextSnippetExporter >> visitFileReferenceAnnotation: aLeFileReferenceAnnotationNode [
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
GtLTextSnippetExporter >> visitHeader: aLeHeaderNode [
	stream
		nextPutAll: ('#' repeat: aLeHeaderNode numberSigns size + startHeaderLevel);
		space;
		nextPutAll: aLeHeaderNode headerName asString trim
]

{ #category : #'as yet unclassified' }
GtLTextSnippetExporter >> visitInlineCode: aLeInlineCodeNode [ 
	stream nextPutAll: aLeInlineCodeNode source
]

{ #category : #'as yet unclassified' }
GtLTextSnippetExporter >> visitItalic: aLeItalicNode [ 
	stream nextPutAll: aLeItalicNode source
]

{ #category : #'as yet unclassified' }
GtLTextSnippetExporter >> visitMethodAnnotation: aLeMethodAnnotationNode [
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
GtLTextSnippetExporter >> visitPackageAnnotation: aLePackageAnnotationNode [
	stream nextPutAll: aLePackageAnnotationNode parent source
]

{ #category : #'as yet unclassified' }
GtLTextSnippetExporter >> visitPageAnnotation: aLePageAnnotationNode [
	stream nextPutAll: aLePageAnnotationNode parent source
]

{ #category : #'as yet unclassified' }
GtLTextSnippetExporter >> visitPragmaAnnotation: aLePragmaAnnotationNode [ 
	stream nextPutAll: aLePragmaAnnotationNode parent source
]

{ #category : #'as yet unclassified' }
GtLTextSnippetExporter >> visitString: aLeStringNode [
	aLeStringNode parts do: [ :aPart | aPart acceptVisitor: self ]
]

{ #category : #'as yet unclassified' }
GtLTextSnippetExporter >> visitText: aLeTextNode [ 
	stream nextPutAll: aLeTextNode content
]

{ #category : #'as yet unclassified' }
GtLTextSnippetExporter >> visitTodoAnnotation: aLeTodoAnnotationNode [
	stream nextPutAll: aLeTodoAnnotationNode parent source
]

{ #category : #'as yet unclassified' }
GtLTextSnippetExporter >> visitWordAnnotation: aLeWordAnnotationNode [ 
	stream nextPutAll: aLeWordAnnotationNode parent source
]
