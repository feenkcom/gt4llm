Class {
	#name : #GtLlmLepiterContentExporter,
	#superclass : #Object,
	#instVars : [
		'page',
		'stream',
		'level'
	],
	#category : #'Gt4Llm-GToolkit-Exporter'
}

{ #category : #'as yet unclassified' }
GtLlmLepiterContentExporter >> codeSnippet: aString labelled: aName [
	stream
		nextPutAll: '```' , aName
				, '
' , (aString ifNil: [ '' ])
				, '
```'
]

{ #category : #'as yet unclassified' }
GtLlmLepiterContentExporter >> export [
	stream := WriteStream on: ''.
	level := 0.
	page acceptVisitor: self.
	^ stream contents
]

{ #category : #'as yet unclassified' }
GtLlmLepiterContentExporter >> heading: aString [
	^ self heading: aString level: 1
]

{ #category : #'as yet unclassified' }
GtLlmLepiterContentExporter >> heading: aString level: anInteger [
	^ ('#' repeat: anInteger) , ' ' , aString
]

{ #category : #'as yet unclassified' }
GtLlmLepiterContentExporter >> indent: aString [
	^ aString"
	level = 0 ifTrue: [ ^ aString ].
	^ ('    ' repeat: level) , '- ' , aString"
]

{ #category : #'as yet unclassified' }
GtLlmLepiterContentExporter >> linebreaks [
	stream
		nextPut: Character linefeed;
		nextPut: Character linefeed
]

{ #category : #accessing }
GtLlmLepiterContentExporter >> page [
	^ page
]

{ #category : #accessing }
GtLlmLepiterContentExporter >> page: anObject [
	page := anObject
]

{ #category : #'as yet unclassified' }
GtLlmLepiterContentExporter >> treatTextSnippetAst: anAst [
	^ GtLlmTextSnippetExporter new exportAst: anAst
]

{ #category : #'as yet unclassified' }
GtLlmLepiterContentExporter >> visitChangesSnippet: aLeChangesSnippet [
	self codeSnippet: aLeChangesSnippet contentAsString labelled: 'changes'.

	self visitChildren: aLeChangesSnippet
]

{ #category : #'as yet unclassified' }
GtLlmLepiterContentExporter >> visitChildren: aSnippet [
	level := level + 1.
	aSnippet children size > 0 ifTrue: [ self linebreaks ].
	aSnippet
		childrenDo: [ :aChild | 
			aChild acceptVisitor: self.
			self linebreaks ].
	level := level - 1
]

{ #category : #'as yet unclassified' }
GtLlmLepiterContentExporter >> visitElementSnippet: aLeElementSnippet [
	self codeSnippet: aLeElementSnippet code labelled: 'element'.

	self visitChildren: aLeElementSnippet
]

{ #category : #'as yet unclassified' }
GtLlmLepiterContentExporter >> visitExampleSnippet: aLeExampleSnippet [
	self
		codeSnippet: (aLeExampleSnippet exampleMethod
				ifNil: [ aLeExampleSnippet contentAsString ]
				ifNotNil: [ aLeExampleSnippet inlinedSnippetSource ])
		labelled: 'example'.

	self visitChildren: aLeExampleSnippet
]

{ #category : #'as yet unclassified' }
GtLlmLepiterContentExporter >> visitGQLSnippet: aGtGQLSnippet [
	self codeSnippet: aGtGQLSnippet contentAsString labelled: 'graphql'.

	self visitChildren: aGtGQLSnippet
]

{ #category : #'as yet unclassified' }
GtLlmLepiterContentExporter >> visitGemStoneSnippet: aLeGemStoneSnippet [ 
	self codeSnippet: aLeGemStoneSnippet code labelled: 'gemstone'.

	self visitChildren: aLeGemStoneSnippet
]

{ #category : #'as yet unclassified' }
GtLlmLepiterContentExporter >> visitJavaScriptSnippet: aLeJavaScriptSnippet [
	self codeSnippet: aLeJavaScriptSnippet code labelled: 'javascript'.

	self visitChildren: aLeJavaScriptSnippet
]

{ #category : #'as yet unclassified' }
GtLlmLepiterContentExporter >> visitPage: aLePage [
	stream nextPutAll: (self heading: aLePage title).
	
	self linebreaks.

	aLePage
		childrenDo: [ :aChild | 
			aChild acceptVisitor: self.
			self linebreaks ]
]

{ #category : #'as yet unclassified' }
GtLlmLepiterContentExporter >> visitPharoLinkSnippet: aLePharoLinkSnippet [ 
	self codeSnippet: aLePharoLinkSnippet code labelled: 'remote-pharo'.

	self visitChildren: aLePharoLinkSnippet
]

{ #category : #'as yet unclassified' }
GtLlmLepiterContentExporter >> visitPharoRewriteSnippet: aLePharoRewriteSnippet [
	self
		codeSnippet: aLePharoRewriteSnippet contentAsString
		labelled: 'pharo-rewrite'.

	self visitChildren: aLePharoRewriteSnippet
]

{ #category : #'as yet unclassified' }
GtLlmLepiterContentExporter >> visitPharoSnippet: aLePharoSnippet [
	self codeSnippet: aLePharoSnippet code labelled: 'pharo'.

	self visitChildren: aLePharoSnippet
]

{ #category : #'as yet unclassified' }
GtLlmLepiterContentExporter >> visitPictureSnippet: aLePictureSnippet [
	stream nextPutAll: aLePictureSnippet urlString trimBoth.

	self visitChildren: aLePictureSnippet
]

{ #category : #'as yet unclassified' }
GtLlmLepiterContentExporter >> visitPythonSnippet: aLePythonSnippet [ 
	self codeSnippet: aLePythonSnippet code labelled: 'python'.

	self visitChildren: aLePythonSnippet
]

{ #category : #'as yet unclassified' }
GtLlmLepiterContentExporter >> visitSnippet: aSnippet [
	stream nextPutAll: aSnippet contentAsString.

	self visitChildren: aSnippet
]

{ #category : #'as yet unclassified' }
GtLlmLepiterContentExporter >> visitTextSnippet: aLeTextSnippet [
	stream nextPutAll: (self treatTextSnippetAst: aLeTextSnippet ast).

	self visitChildren: aLeTextSnippet
]

{ #category : #'as yet unclassified' }
GtLlmLepiterContentExporter >> visitTextualSnippet: aTextualSnippet [
	stream nextPutAll: aTextualSnippet text.

	self visitChildren: aTextualSnippet
]

{ #category : #'as yet unclassified' }
GtLlmLepiterContentExporter >> visitUnknownSnippet: aLeUnknownSnippet [ 
	self codeSnippet: aLeUnknownSnippet jsonString labelled: 'unknown'.

	self visitChildren: aLeUnknownSnippet
]

{ #category : #'as yet unclassified' }
GtLlmLepiterContentExporter >> visitWardleyMapSnippet: aLeWardleyMapSnippet [
	self
		codeSnippet: aLeWardleyMapSnippet wardleyMap asWardleyMapScript
		labelled: 'wardley-map'.

	self visitChildren: aLeWardleyMapSnippet
]

{ #category : #'as yet unclassified' }
GtLlmLepiterContentExporter >> visitWordSnippet: aLeWordSnippet [
	| explanation |
	explanation := aLeWordSnippet explanation.
	stream
		nextPutAll: '**' , explanation word , '**';
		nextPut: Character linefeed.
	explanation meanings
		do: [ :aMeaning | 
			stream
				nextPutAll: '*' , aMeaning partOfSpeech , '*';
				nextPut: Character linefeed.
			aMeaning definitions
				do: [ :aDefinition | 
					stream
						nextPutAll: aDefinition definition;
						nextPut: Character linefeed.
					aDefinition exampleSentence
						ifNotNil: [ :aSentence | 
							stream
								nextPutAll: '*' , aSentence , '*';
								nextPut: Character linefeed ] ] ]
]

{ #category : #'as yet unclassified' }
GtLlmLepiterContentExporter >> visitYoutubeReferenceSnippet: aLeYoutubeReferenceSnippet [
	stream
		nextPutAll: '[youtube link](' , aLeYoutubeReferenceSnippet urlString , ')'.

	self visitChildren: aLeYoutubeReferenceSnippet
]
