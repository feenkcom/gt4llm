Class {
	#name : #GtLlmPageExporter,
	#superclass : #Object,
	#instVars : [
		'page',
		'stream',
		'level'
	],
	#category : #'Gt4Llm-GToolkit-Exporter'
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

	self visit: page.

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
GtLlmPageExporter >> visit: aPage [ 
	^ aPage acceptVisitor: self
]

{ #category : #'as yet unclassified' }
GtLlmPageExporter >> visitChangesSnippet: aLeChangesSnippet [
	self codeSnippet: aLeChangesSnippet contentAsString labelled: 'changes'.

	self visitChildren: aLeChangesSnippet
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
GtLlmPageExporter >> visitElementSnippet: aLeElementSnippet [
	self codeSnippet: aLeElementSnippet code labelled: 'element'.

	self visitChildren: aLeElementSnippet
]

{ #category : #'as yet unclassified' }
GtLlmPageExporter >> visitExampleSnippet: aLeExampleSnippet [
	self codeSnippet: aLeExampleSnippet referencedExampleSourceCode labelled: 'example'.

	self visitChildren: aLeExampleSnippet
]

{ #category : #'as yet unclassified' }
GtLlmPageExporter >> visitGQLSnippet: aGtGQLSnippet [
	self codeSnippet: aGtGQLSnippet contentAsString labelled: 'graphql'.

	self visitChildren: aGtGQLSnippet
]

{ #category : #'as yet unclassified' }
GtLlmPageExporter >> visitGemStoneSnippet: aLeGemStoneSnippet [ 
	self codeSnippet: aLeGemStoneSnippet code labelled: 'gemstone'.

	self visitChildren: aLeGemStoneSnippet
]

{ #category : #'as yet unclassified' }
GtLlmPageExporter >> visitJavaScriptSnippet: aLeJavaScriptSnippet [
	self codeSnippet: aLeJavaScriptSnippet code labelled: 'javascript'.

	self visitChildren: aLeJavaScriptSnippet
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
GtLlmPageExporter >> visitPharoRewriteSnippet: aLePharoRewriteSnippet [
	self
		codeSnippet: aLePharoRewriteSnippet contentAsString
		labelled: 'pharo-rewrite'.

	self visitChildren: aLePharoRewriteSnippet
]

{ #category : #'as yet unclassified' }
GtLlmPageExporter >> visitPharoSnippet: aLePharoSnippet [
	self codeSnippet: aLePharoSnippet code labelled: 'pharo'.

	self visitChildren: aLePharoSnippet
]

{ #category : #'as yet unclassified' }
GtLlmPageExporter >> visitPictureSnippet: aLePictureSnippet [
	stream nextPutAll: aLePictureSnippet urlString trimBoth.

	self visitChildren: aLePictureSnippet
]

{ #category : #'as yet unclassified' }
GtLlmPageExporter >> visitPythonSnippet: aLePythonSnippet [ 
	self codeSnippet: aLePythonSnippet code labelled: 'python'.

	self visitChildren: aLePythonSnippet
]

{ #category : #'as yet unclassified' }
GtLlmPageExporter >> visitSnippet: aSnippet [
	stream nextPutAll: aSnippet contentAsString.

	self visitChildren: aSnippet
]

{ #category : #'as yet unclassified' }
GtLlmPageExporter >> visitTextSnippet: aLeTextSnippet [
	stream nextPutAll: (self treatTextSnippetAst: aLeTextSnippet ast).

	self visitChildren: aLeTextSnippet
]

{ #category : #'as yet unclassified' }
GtLlmPageExporter >> visitTextualSnippet: aTextualSnippet [
	stream nextPutAll: aTextualSnippet text.

	self visitChildren: aTextualSnippet
]

{ #category : #'as yet unclassified' }
GtLlmPageExporter >> visitUnknownSnippet: aLeUnknownSnippet [ 
	self codeSnippet: aLeUnknownSnippet jsonString labelled: 'unknown'.

	self visitChildren: aLeUnknownSnippet
]

{ #category : #'as yet unclassified' }
GtLlmPageExporter >> visitWardleyMapSnippet: aLeWardleyMapSnippet [
	self
		codeSnippet: aLeWardleyMapSnippet wardleyMap asWardleyMapScript
		labelled: 'wardley-map'.

	self visitChildren: aLeWardleyMapSnippet
]

{ #category : #'as yet unclassified' }
GtLlmPageExporter >> visitYoutubeReferenceSnippet: aLeYoutubeReferenceSnippet [
	stream
		nextPutAll: '[youtube link](' , aLeYoutubeReferenceSnippet urlString , ')'.

	self visitChildren: aLeYoutubeReferenceSnippet
]
