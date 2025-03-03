Class {
	#name : #GtBPEEncoder,
	#superclass : #Object,
	#instVars : [
		'vocabularySize'
	],
	#category : #Gt4Llm
}

{ #category : #accessing }
GtBPEEncoder >> defaultVocabularySize [
	^ 286
]

{ #category : #accessing }
GtBPEEncoder >> encode: aString [
	| tokens stats mergeResult |
	tokens := self tokenize: aString.
	stats := self getStatsFor: tokens.
	mergeResult := self mergeTokens: tokens withVocabularySize: self vocabularySize.
	^ GtBPEEncodingResult new
		input: aString;
		tokens: tokens;
		stats: stats;
		merges: mergeResult merges;
		output: mergeResult output
]

{ #category : #accessing }
GtBPEEncoder >> initialize [
	super initialize.
	
	vocabularySize := self defaultVocabularySize
]

{ #category : #accessing }
GtBPEEncoder >> mergePair: aPair into: anId inTokens: tokens [
	| result anIndex |
	result := OrderedCollection new.
	anIndex := 1.
	[ anIndex <= tokens size ]
		whileTrue: [ (anIndex < (tokens size - 1)
				and: [ aPair
						= {tokens at: anIndex.
								tokens at: anIndex + 1} ])
				ifTrue: [ result add: anId.
					anIndex := anIndex + 2 ]
				ifFalse: [ result add: (tokens at: anIndex).
					anIndex := anIndex + 1 ] ].
	^ result
]

{ #category : #accessing }
GtBPEEncoder >> mergeTokens: aListOfTokens withVocabularySize: anInteger [
	| numberOfMerges aResult merges |
	numberOfMerges := anInteger - 256.
	aResult := aListOfTokens.
	merges := Dictionary new.
	1
		to: numberOfMerges
		do: [ :anIndex | 
			| currentStats pair newId |
			currentStats := self getStatsFor: aResult.
			pair := currentStats mostFrequent.
			newId := 256 + anIndex.
			aResult := self
					mergePair: pair
					into: newId
					inTokens: aResult.
			merges at: pair put: newId ].
	^ GtBPEMergeResult new merges: merges; output: aResult
]

{ #category : #accessing }
GtBPEEncoder >> tokenize: aString [ 
	^ aString asUTF8Bytes
]

{ #category : #accessing }
GtBPEEncoder >> vocabularySize [
	^ vocabularySize
]

{ #category : #accessing }
GtBPEEncoder >> vocabularySize: anObject [
	vocabularySize := anObject
]
