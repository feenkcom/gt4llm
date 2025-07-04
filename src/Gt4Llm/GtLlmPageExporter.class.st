Class {
	#name : #GtLlmPageExporter,
	#superclass : #Object,
	#instVars : [
		'page',
		'stream',
		'level'
	],
	#category : #'Gt4Llm-Exporter'
}

{ #category : #'as yet unclassified' }
GtLlmPageExporter >> codeSnippet: aString labelled: aName [ 
	stream nextPutAll: '```', aName, '
', aString, '
```'
]

{ #category : #'as yet unclassified' }
GtLlmPageExporter >> export [
	stream := WriteStream on: ''.
	level := 0.

	page acceptVisitor: self.

	^ stream contents
]

{ #category : #'as yet unclassified' }
GtLlmPageExporter >> heading: aString [
	^ self heading: aString level: 1
]

{ #category : #'as yet unclassified' }
GtLlmPageExporter >> heading: aString level: anInteger [
	^ ('#' repeat: anInteger) , ' ' , aString
]

{ #category : #'as yet unclassified' }
GtLlmPageExporter >> indent: aString [
	^ aString"
	level = 0 ifTrue: [ ^ aString ].
	^ ('    ' repeat: level) , '- ' , aString"
]

{ #category : #'as yet unclassified' }
GtLlmPageExporter >> linebreaks [
	stream
		nextPut: Character linefeed;
		nextPut: Character linefeed
]

{ #category : #accessing }
GtLlmPageExporter >> page [
	^ page
]

{ #category : #accessing }
GtLlmPageExporter >> page: anObject [
	page := anObject
]

{ #category : #'as yet unclassified' }
GtLlmPageExporter >> treatTextSnippetAst: anAst [
	^ GtLlmTextSnippetExporter new exportAst: anAst
]

{ #category : #'as yet unclassified' }
GtLlmPageExporter >> visitChildren: aSnippet [
	level := level + 1.
	aSnippet children size > 0 ifTrue: [ self linebreaks ].
	aSnippet
		childrenDo: [ :aChild | 
			aChild acceptVisitor: self.
			self linebreaks ].
	level := level - 1
]

{ #category : #'as yet unclassified' }
GtLlmPageExporter >> visitExampleSnippet: aLeExampleSnippet [
	self codeSnippet: aLeExampleSnippet referencedExampleSourceCode labelled: 'example'.

	self visitChildren: aLeExampleSnippet
]

{ #category : #'as yet unclassified' }
GtLlmPageExporter >> visitPage: aLePage [
	stream nextPutAll: (self heading: aLePage title).
	
	self linebreaks.

	aLePage
		childrenDo: [ :aChild | 
			aChild acceptVisitor: self.
			self linebreaks ]
]

{ #category : #'as yet unclassified' }
GtLlmPageExporter >> visitTextSnippet: aLeTextSnippet [
	stream nextPutAll: (self treatTextSnippetAst: aLeTextSnippet ast).

	self visitChildren: aLeTextSnippet
]
