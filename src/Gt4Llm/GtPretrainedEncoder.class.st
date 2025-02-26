Class {
	#name : #GtPretrainedEncoder,
	#superclass : #Object,
	#instVars : [
		'merges',
		'reversedMerges'
	],
	#category : #Gt4Llm
}

{ #category : #accessing }
GtPretrainedEncoder >> decode: aListOfTokens [
	| aResult |
	aResult := OrderedCollection new.
	aListOfTokens
		do: [ :aToken | aResult addAll: (self reversedMerges at: aToken ifAbsent: [ {aToken} ]) ].
	^ ZnUTF8Encoder default decodeBytes: aResult
]

{ #category : #accessing }
GtPretrainedEncoder >> encode: aString [
	| encoder tokens continue |
	encoder := GtBPEEncoder new.
	tokens := encoder tokenize: aString.
	continue := true.
	[ continue ]
		whileTrue: [ | stats pair |
			stats := encoder getStatsFor: tokens.
			pair := stats keys
					detectMin: [ :aPair | merges at: aPair ifAbsent: Float infinity ].
			(merges includesKey: pair)
				ifTrue: [ tokens := encoder
							mergePair: pair
							into: (merges at: pair)
							inTokens: tokens.
					continue := tokens size >= 2 ]
				ifFalse: [ continue := false ] ].
	^ tokens
]

{ #category : #accessing }
GtPretrainedEncoder >> gtMergesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Merges';
		priority: 4;
		items: [ self merges associations ];
		column: 'Input pair' text: [ :aPair | ', ' join: aPair key ];
		column: 'Output token' text: #value
]

{ #category : #accessing }
GtPretrainedEncoder >> merges [
	^ merges
]

{ #category : #accessing }
GtPretrainedEncoder >> merges: anObject [
	merges := anObject.

	self reversedMergesFromMerges
]

{ #category : #accessing }
GtPretrainedEncoder >> reversedMergeFor: aKeyList in: simplyReversedMerges [
	| aResult nextKeys |
	aResult := OrderedCollection new.
	nextKeys := aKeyList asOrderedCollection.
	[ nextKeys isNotEmpty ]
		whileTrue: [ | nextKey |
			nextKey := nextKeys removeFirst.
			(simplyReversedMerges includesKey: nextKey)
				ifTrue: [ nextKeys addAllFirst: (simplyReversedMerges at: nextKey) ]
				ifFalse: [ aResult add: nextKey ] ].
	^ aResult
]

{ #category : #accessing }
GtPretrainedEncoder >> reversedMerges [
	^ reversedMerges
]

{ #category : #accessing }
GtPretrainedEncoder >> reversedMerges: anObject [
	reversedMerges := anObject
]

{ #category : #accessing }
GtPretrainedEncoder >> reversedMergesFromMerges [
	| simplyReversedMerges |
	simplyReversedMerges := (self merges associations
			collect: [ :anAssociation | Association key: anAssociation value value: anAssociation key ])
			asDictionary.
	self
		reversedMerges: (simplyReversedMerges
				collect: [ :aValue | self reversedMergeFor: aValue in: simplyReversedMerges ])
]
