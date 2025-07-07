Class {
	#name : #GtLlmTextSnippetExporter,
	#superclass : #Object,
	#instVars : [
		'stream'
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
GtLlmTextSnippetExporter >> visit: anAst [
	^ anAst acceptVisitor: self
]

{ #category : #'as yet unclassified' }
GtLlmTextSnippetExporter >> visitBold: aLeBoldNode [ 
	stream nextPutAll: aLeBoldNode source
]

{ #category : #'as yet unclassified' }
GtLlmTextSnippetExporter >> visitCodeBlock: aLeCodeBlockNode [
	stream nextPutAll: aLeCodeBlockNode source
]

{ #category : #'as yet unclassified' }
GtLlmTextSnippetExporter >> visitDocumenterAnnotation: aLeDocumenterAnnotationNode [
	aLeDocumenterAnnotationNode annotation expanded
		ifTrue: [ | methodOrClass |
			methodOrClass := aLeDocumenterAnnotationNode annotation nameNode imageObject.
			methodOrClass
				ifNil: [ stream nextPutAll: aLeDocumenterAnnotationNode source ]
				ifNotNil: [ methodOrClass isClass
						ifTrue: [ stream
								nextPutAll: '

```smalltalk
' , methodOrClass definitionString
										, '
```

' ]
						ifFalse: [ stream
								nextPutAll: '

```smalltalk-method
' , methodOrClass methodClass asString , '>>' , methodOrClass sourceCode
										, '
```

' ] ] ]
		ifFalse: [ stream nextPutAll: aLeDocumenterAnnotationNode source ]
]

{ #category : #'as yet unclassified' }
GtLlmTextSnippetExporter >> visitDoubleBracketLink: aLeDoubleBracketLinkNode [ 
	stream nextPutAll: aLeDoubleBracketLinkNode source
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
	stream nextPutAll: aLeHeaderNode source
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
GtLlmTextSnippetExporter >> visitString: aLeStringNode [
	aLeStringNode parts do: [ :aPart | aPart acceptVisitor: self ]
]

{ #category : #'as yet unclassified' }
GtLlmTextSnippetExporter >> visitText: aLeTextNode [ 
	stream nextPutAll: aLeTextNode content
]
