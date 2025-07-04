Class {
	#name : #GtLlmTextSnippetExporter,
	#superclass : #Object,
	#instVars : [
		'stream'
	],
	#category : #'Gt4Llm-Exporter'
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
GtLlmTextSnippetExporter >> visitDocumenterAnnotation: aLeDocumenterAnnotationNode [
	aLeDocumenterAnnotationNode annotation expanded
		ifTrue: [ | method |
			method := aLeDocumenterAnnotationNode annotation nameNode imageObject.
			stream
				nextPutAll: '

```smalltalk-method
' , method methodClass asString , '>>' , method sourceCode
						, '
```

' ]
		ifFalse: [ stream nextPutAll: aLeDocumenterAnnotationNode source ]
]

{ #category : #'as yet unclassified' }
GtLlmTextSnippetExporter >> visitDoubleBracketLink: aLeDoubleBracketLinkNode [ 
	stream nextPutAll: aLeDoubleBracketLinkNode source
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
GtLlmTextSnippetExporter >> visitString: aLeStringNode [
	aLeStringNode parts do: [ :aPart | aPart acceptVisitor: self ]
]

{ #category : #'as yet unclassified' }
GtLlmTextSnippetExporter >> visitText: aLeTextNode [ 
	stream nextPutAll: aLeTextNode content
]
