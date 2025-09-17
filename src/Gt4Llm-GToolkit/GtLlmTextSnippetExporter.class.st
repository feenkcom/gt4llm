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
