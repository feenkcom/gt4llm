Class {
	#name : #GtLLepiterContentExporter,
	#superclass : #Object,
	#instVars : [
		'stream',
		'level',
		'toExport',
		'startHeaderLevel'
	],
	#category : #'Gt4LlmCore-Exporter'
}

{ #category : #'as yet unclassified' }
GtLLepiterContentExporter >> childrenOf: aContent [
	toExport addAll: aContent children
]

{ #category : #'as yet unclassified' }
GtLLepiterContentExporter >> codeSnippet: aString labelled: aName [
	stream
		nextPutAll: '```' , aName
				, '
' , (aString ifNil: [ '' ])
				, '
```'
]

{ #category : #accessing }
GtLLepiterContentExporter >> content: aLepiterContent [
	toExport add: aLepiterContent
]

{ #category : #'as yet unclassified' }
GtLLepiterContentExporter >> export [
	stream := WriteStream on: ''.
	level := 0.
	toExport do: [ :each | self visit: each ].
	^ stream contents
]

{ #category : #'as yet unclassified' }
GtLLepiterContentExporter >> heading: aString level: anInteger [
	^ ('#' repeat: anInteger) , ' ' , aString
]

{ #category : #'as yet unclassified' }
GtLLepiterContentExporter >> indent: aString [
	^ aString"
	level = 0 ifTrue: [ ^ aString ].
	^ ('    ' repeat: level) , '- ' , aString"
]

{ #category : #'as yet unclassified' }
GtLLepiterContentExporter >> initialize [
	super initialize.
	toExport := OrderedCollection new.
	startHeaderLevel := 1.
]

{ #category : #'as yet unclassified' }
GtLLepiterContentExporter >> linebreaks [
	stream
		nextPut: Character linefeed;
		nextPut: Character linefeed
]

{ #category : #accessing }
GtLLepiterContentExporter >> page: aLepiterContent [
	toExport add: aLepiterContent
]

{ #category : #accessing }
GtLLepiterContentExporter >> startHeaderLevel [
	^ startHeaderLevel
]

{ #category : #accessing }
GtLLepiterContentExporter >> startHeaderLevel: anObject [
	startHeaderLevel := anObject
]

{ #category : #'as yet unclassified' }
GtLLepiterContentExporter >> visit: each [
	"we use it to preserve the pattern we use throughout GT"
	^ each acceptVisitor: self
]

{ #category : #'as yet unclassified' }
GtLLepiterContentExporter >> visitBlockQuoteSnippet: aTextualSnippet [
	self codeSnippet: aTextualSnippet text asString labelled: ''.

	self visitChildren: aTextualSnippet
]

{ #category : #'as yet unclassified' }
GtLLepiterContentExporter >> visitChangesSnippet: aLeChangesSnippet [
	self codeSnippet: aLeChangesSnippet contentAsString labelled: 'changes'.

	self visitChildren: aLeChangesSnippet
]

{ #category : #'as yet unclassified' }
GtLLepiterContentExporter >> visitChildren: aSnippet [
	level := level + 1.
	aSnippet children size > 0 ifTrue: [ self linebreaks ].
	aSnippet
		childrenDo: [ :aChild | 
			aChild acceptVisitor: self.
			self linebreaks ].
	level := level - 1
]

{ #category : #'as yet unclassified' }
GtLLepiterContentExporter >> visitElementSnippet: aLeElementSnippet [
	self codeSnippet: aLeElementSnippet code labelled: 'element'.

	self visitChildren: aLeElementSnippet
]

{ #category : #'as yet unclassified' }
GtLLepiterContentExporter >> visitExampleSnippet: aLeExampleSnippet [
	self
		codeSnippet: (aLeExampleSnippet exampleMethod
				ifNil: [ aLeExampleSnippet contentAsString ]
				ifNotNil: [ aLeExampleSnippet inlinedSnippetSource ])
		labelled: 'pharo'.

	self visitChildren: aLeExampleSnippet
]

{ #category : #'as yet unclassified' }
GtLLepiterContentExporter >> visitGQLSnippet: aGtGQLSnippet [
	self codeSnippet: aGtGQLSnippet contentAsString labelled: 'graphql'.

	self visitChildren: aGtGQLSnippet
]

{ #category : #'as yet unclassified' }
GtLLepiterContentExporter >> visitGemStoneSnippet: aLeGemStoneSnippet [ 
	self codeSnippet: aLeGemStoneSnippet code labelled: 'gemstone'.

	self visitChildren: aLeGemStoneSnippet
]

{ #category : #'as yet unclassified' }
GtLLepiterContentExporter >> visitJavaScriptSnippet: aLeJavaScriptSnippet [
	self codeSnippet: aLeJavaScriptSnippet code labelled: 'javascript'.

	self visitChildren: aLeJavaScriptSnippet
]

{ #category : #'as yet unclassified' }
GtLLepiterContentExporter >> visitPage: aLePage [
	stream nextPutAll: (self heading: aLePage title level: startHeaderLevel).

	self linebreaks.

	aLePage
		childrenDo: [ :aChild | 
			aChild acceptVisitor: self.
			self linebreaks ]
]

{ #category : #'as yet unclassified' }
GtLLepiterContentExporter >> visitPharoLinkSnippet: aLePharoLinkSnippet [ 
	self codeSnippet: aLePharoLinkSnippet code labelled: 'remote-pharo'.

	self visitChildren: aLePharoLinkSnippet
]

{ #category : #'as yet unclassified' }
GtLLepiterContentExporter >> visitPharoRewriteSnippet: aLePharoRewriteSnippet [
	self
		codeSnippet: aLePharoRewriteSnippet contentAsString
		labelled: 'pharo-rewrite'.

	self visitChildren: aLePharoRewriteSnippet
]

{ #category : #'as yet unclassified' }
GtLLepiterContentExporter >> visitPharoSnippet: aLePharoSnippet [
	self codeSnippet: aLePharoSnippet code labelled: 'pharo'.

	self visitChildren: aLePharoSnippet
]

{ #category : #'as yet unclassified' }
GtLLepiterContentExporter >> visitPictureSnippet: aLePictureSnippet [
	stream nextPutAll: aLePictureSnippet urlString trimBoth.

	self visitChildren: aLePictureSnippet
]

{ #category : #'as yet unclassified' }
GtLLepiterContentExporter >> visitPythonSnippet: aLePythonSnippet [ 
	self codeSnippet: aLePythonSnippet code labelled: 'python'.

	self visitChildren: aLePythonSnippet
]

{ #category : #'as yet unclassified' }
GtLLepiterContentExporter >> visitSnippet: aSnippet [
	stream nextPutAll: aSnippet contentAsString.

	self visitChildren: aSnippet
]

{ #category : #'as yet unclassified' }
GtLLepiterContentExporter >> visitTextSnippet: aLeTextSnippet [
	stream
		nextPutAll: (GtLTextSnippetExporter new
				startHeaderLevel: startHeaderLevel;
				exportAst: aLeTextSnippet ast).

	self visitChildren: aLeTextSnippet
]

{ #category : #'as yet unclassified' }
GtLLepiterContentExporter >> visitTextualSnippet: aTextualSnippet [
	stream nextPutAll: aTextualSnippet text.

	self visitChildren: aTextualSnippet
]

{ #category : #'as yet unclassified' }
GtLLepiterContentExporter >> visitUnknownSnippet: aLeUnknownSnippet [ 
	self codeSnippet: aLeUnknownSnippet jsonString labelled: 'unknown'.

	self visitChildren: aLeUnknownSnippet
]

{ #category : #'as yet unclassified' }
GtLLepiterContentExporter >> visitWardleyMapSnippet: aLeWardleyMapSnippet [
	self
		codeSnippet: aLeWardleyMapSnippet wardleyMap asWardleyMapScript
		labelled: 'wardley-map'.

	self visitChildren: aLeWardleyMapSnippet
]

{ #category : #'as yet unclassified' }
GtLLepiterContentExporter >> visitWordSnippet: aLeWordSnippet [
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
GtLLepiterContentExporter >> visitYoutubeReferenceSnippet: aLeYoutubeReferenceSnippet [
	stream
		nextPutAll: '[youtube link](' , aLeYoutubeReferenceSnippet urlString , ')'.

	self visitChildren: aLeYoutubeReferenceSnippet
]
