Class {
	#name : #GtBPEEncoderExamples,
	#superclass : #Object,
	#category : #Gt4Llm
}

{ #category : #'as yet unclassified' }
GtBPEEncoderExamples >> bpeEncoderWithMergedTokens [
	<gtExample>
	| encoder tokens result |
	encoder := GtBPEEncoder new.
	tokens := encoder tokenize: 'aaaa'.
	result := encoder mergeTokens: tokens withVocabularySize: 258.
	self assert: (result merges at: #(97 97)) equals: 257.
	self assert: (result merges at: #(257 97)) equals: 258.
	self assert: result output size equals: 2.
	self assert: result output equals: #(258 97) asOrderedCollection.
	^ encoder
]

{ #category : #accessing }
GtBPEEncoderExamples >> encodedLorem [
	<gtExample>
	| encoder encoded |
	encoder := GtBPEEncoder new.
	encoded := encoder encode: String loremIpsum.
	
	self assert: encoded output size equals: 300.
	self assert: encoded compressionRatio > 1.
	
	^ encoded
]

{ #category : #accessing }
GtBPEEncoderExamples >> preTrainedEncoderLorem [
	<gtExample>
	| encoder encoded |
	encoder := GtPretrainedEncoder new merges: self encodedLorem merges.
	encoded := encoder encode: String loremIpsum.
	
	self assert: encoded size equals: 300.
	self assert: (encoder decode: encoded) equals: String loremIpsum.
	
	^ encoded
]
