"
I split text recursively using a prioritized list of separators, adapting LangChain's RecursiveCharacterTextSplitter behavior to Smalltalk/GT.

I first choose the first separator that appears in the text. I split the text with that separator while optionally keeping the separator at the start or end of resulting parts. Then I merge adjacent small parts into chunks up to a target chunk size with optional overlap. When a part is still too large, I recurse with the remaining separators.

This class currently supports literal separators (not regex separators).
"
Class {
	#name : #GtRecursiveCharacterTextSplitter,
	#superclass : #Object,
	#instVars : [
		'chunkSize',
		'chunkOverlap',
		'keepSeparator',
		'separators',
		'stripWhitespace'
	],
	#category : #'Gt4Llm-VectorDb-TextPreparation'
}

{ #category : #'instance creation' }
GtRecursiveCharacterTextSplitter class >> default [
	^ self new
]

{ #category : #splitting }
GtRecursiveCharacterTextSplitter >> attachSeparatorAtStart: separator toPieces: pieces [
	| normalized |
	normalized := OrderedCollection new.
	pieces withIndexDo: [ :each :index |
		each isEmpty ifFalse: [
			normalized add: (index = 1
				ifTrue: [ each ]
				ifFalse: [ separator , each ]) ] ].
	^ normalized asArray
]

{ #category : #accessing }
GtRecursiveCharacterTextSplitter >> beDropSeparator [
	keepSeparator := false
]

{ #category : #accessing }
GtRecursiveCharacterTextSplitter >> beKeepSeparatorAtEnd [
	keepSeparator := #end
]

{ #category : #accessing }
GtRecursiveCharacterTextSplitter >> beKeepSeparatorAtStart [
	keepSeparator := #start
]

{ #category : #accessing }
GtRecursiveCharacterTextSplitter >> chunkOverlap [
	^ chunkOverlap
]

{ #category : #accessing }
GtRecursiveCharacterTextSplitter >> chunkOverlap: anInteger [
	chunkOverlap := anInteger
]

{ #category : #accessing }
GtRecursiveCharacterTextSplitter >> chunkSize [
	^ chunkSize
]

{ #category : #accessing }
GtRecursiveCharacterTextSplitter >> chunkSize: anInteger [
	chunkSize := anInteger
]

{ #category : #'gt-views' }
GtRecursiveCharacterTextSplitter >> gtChunksFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Chunks';
		priority: 10;
		items: [ self gtPreviewChunks ];
		column: 'Index' text: [ :each :index | index asString ];
		column: 'Size' text: [ :each | each size asString ];
		column: 'Chunk' text: [ :each | each ]
]

{ #category : #'gt-views' }
GtRecursiveCharacterTextSplitter >> gtPreviewChunks [
	^ self splitText: self gtSampleText
]

{ #category : #'gt-views' }
GtRecursiveCharacterTextSplitter >> gtSampleText [
	^ 'First paragraph has several words.', String lf, String lf,
		'Second paragraph is here with more text.', String lf,
		'Third line closes the sample.'
]

{ #category : #initialization }
GtRecursiveCharacterTextSplitter >> initialize [
	super initialize.
	chunkSize := 4000.
	chunkOverlap := 200.
	keepSeparator := #start.
	separators := { String lf , String lf . String lf . ' ' . '' }.
	stripWhitespace := true
]

{ #category : #private }
GtRecursiveCharacterTextSplitter >> joinDocs: docs separator: separator [
	| text |
	text := String streamContents: [ :stream |
		docs doWithIndex: [ :each :index |
			index > 1 ifTrue: [ stream nextPutAll: separator ].
			stream nextPutAll: each ] ].
	stripWhitespace ifTrue: [ text := text trimBoth ].
	^ text isEmpty ifTrue: [ nil ] ifFalse: [ text ]
]

{ #category : #accessing }
GtRecursiveCharacterTextSplitter >> keepSeparator [
	^ keepSeparator
]

{ #category : #accessing }
GtRecursiveCharacterTextSplitter >> keepSeparator: aSymbolOrBoolean [
	keepSeparator := aSymbolOrBoolean
]

{ #category : #private }
GtRecursiveCharacterTextSplitter >> lengthOf: aString [
	^ aString size
]

{ #category : #private }
GtRecursiveCharacterTextSplitter >> mergeSplits: splits separator: separator [
	| separatorLength docs currentDoc total |
	separatorLength := self lengthOf: separator.
	docs := OrderedCollection new.
	currentDoc := OrderedCollection new.
	total := 0.
	splits do: [ :each |
		| len |
		len := self lengthOf: each.
		(total + len + (currentDoc isEmpty ifTrue: [ 0 ] ifFalse: [ separatorLength ]) > self chunkSize)
			ifTrue: [
				currentDoc ifNotEmpty: [
					| doc |
					doc := self joinDocs: currentDoc separator: separator.
					doc ifNotNil: [ docs add: doc ].
					[ total > self chunkOverlap
						or: [ total + len + (currentDoc isEmpty ifTrue: [ 0 ] ifFalse: [ separatorLength ]) > self chunkSize
							and: [ total > 0 ] ] ] whileTrue: [
						total := total - (self lengthOf: currentDoc first) - (currentDoc size > 1 ifTrue: [ separatorLength ] ifFalse: [ 0 ]).
						currentDoc removeFirst ] ] ].
		currentDoc add: each.
		total := total + len + (currentDoc size > 1 ifTrue: [ separatorLength ] ifFalse: [ 0 ]) ].
	currentDoc ifNotEmpty: [
		| doc |
		doc := self joinDocs: currentDoc separator: separator.
		doc ifNotNil: [ docs add: doc ] ].
	^ docs asArray
]

{ #category : #splitting }
GtRecursiveCharacterTextSplitter >> normalizeStartKeptPieces: pieces separator: separator original: original [
	| normalized |
	normalized := OrderedCollection new.
	pieces withIndexDo: [ :each :index |
		(index = 1 and: [ each beginsWith: separator ])
			ifTrue: [ normalized add: (each allButFirst: separator size) ]
			ifFalse: [ normalized add: each ] ].
	^ normalized reject: [ :each | each isEmpty ] as: Array
]

{ #category : #accessing }
GtRecursiveCharacterTextSplitter >> separators [
	^ separators
]

{ #category : #accessing }
GtRecursiveCharacterTextSplitter >> separators: aCollection [
	separators := aCollection asArray
]

{ #category : #splitting }
GtRecursiveCharacterTextSplitter >> splitText: aString [
	self validateConfiguration.
	^ self splitText: aString separators: self separators
]

{ #category : #splitting }
GtRecursiveCharacterTextSplitter >> splitText: aString separators: separatorList [
	| finalChunks separator newSeparators splits goodSplits mergeSeparator |
	finalChunks := OrderedCollection new.
	separator := separatorList last.
	newSeparators := #().
	separatorList withIndexDo: [ :each :index |
		each isEmpty
			ifTrue: [
				separator := each.
				^ self splitUsingSeparator: separator remainingSeparators: #() text: aString into: finalChunks ]
			ifFalse: [
				(aString includesSubstring: each)
					ifTrue: [
						separator := each.
						newSeparators := separatorList copyFrom: index + 1 to: separatorList size.
						^ self splitUsingSeparator: separator remainingSeparators: newSeparators text: aString into: finalChunks ] ] ].
	^ self splitUsingSeparator: separator remainingSeparators: newSeparators text: aString into: finalChunks
]

{ #category : #splitting }
GtRecursiveCharacterTextSplitter >> splitTextKeepingSeparator: aString separator: separator mode: keepMode [
	| pieces start index |
	pieces := OrderedCollection new.
	keepMode = #end
		ifTrue: [
			start := 1.
			[index := aString findString: separator startingAt: start.
			index > 0] whileTrue: [
				pieces add: (aString copyFrom: start to: index + separator size - 1).
				start := index + separator size ].
			start <= aString size ifTrue: [ pieces add: (aString copyFrom: start to: aString size) ].
			^ pieces reject: [ :each | each isEmpty ] as: Array ].
	start := 1.
	[index := aString findString: separator startingAt: start.
	index > 0] whileTrue: [
		pieces add: (aString copyFrom: start to: index - 1).
		start := index + separator size ].
	start <= aString size ifTrue: [ pieces add: (aString copyFrom: start to: aString size) ].
	^ self attachSeparatorAtStart: separator toPieces: pieces asArray
]

{ #category : #splitting }
GtRecursiveCharacterTextSplitter >> splitTextWithSeparator: aString separator: separator keepSeparator: keepMode [
	separator isEmpty ifTrue: [ ^ aString collect: #asString as: Array ].
	keepMode = false ifTrue: [ ^ aString substrings: separator ].
	^ self splitTextKeepingSeparator: aString separator: separator mode: keepMode
]

{ #category : #splitting }
GtRecursiveCharacterTextSplitter >> splitUsingSeparator: separator remainingSeparators: remaining text: aString into: finalChunks [
	| splits goodSplits mergeSeparator |
	splits := self splitTextWithSeparator: aString separator: separator keepSeparator: self keepSeparator.
	goodSplits := OrderedCollection new.
	mergeSeparator := self keepSeparator = false
		ifTrue: [ separator ]
		ifFalse: [ '' ].
	splits do: [ :each |
		(self lengthOf: each) < self chunkSize
			ifTrue: [ goodSplits add: each ]
			ifFalse: [
				goodSplits ifNotEmpty: [
					finalChunks addAll: (self mergeSplits: goodSplits separator: mergeSeparator).
					goodSplits := OrderedCollection new ].
				remaining isEmpty
					ifTrue: [ finalChunks add: each ]
					ifFalse: [ finalChunks addAll: (self splitText: each separators: remaining) ] ] ].
	goodSplits ifNotEmpty: [
		finalChunks addAll: (self mergeSplits: goodSplits separator: mergeSeparator) ].
	^ finalChunks asArray
]

{ #category : #accessing }
GtRecursiveCharacterTextSplitter >> stripWhitespace [
	^ stripWhitespace
]

{ #category : #accessing }
GtRecursiveCharacterTextSplitter >> stripWhitespace: aBoolean [
	stripWhitespace := aBoolean
]

{ #category : #initialization }
GtRecursiveCharacterTextSplitter >> validateConfiguration [
	chunkSize <= 0 ifTrue: [ self error: 'chunkSize must be > 0' ].
	chunkOverlap < 0 ifTrue: [ self error: 'chunkOverlap must be >= 0' ].
	chunkOverlap > chunkSize ifTrue: [ self error: 'chunkOverlap must be <= chunkSize' ]
]
