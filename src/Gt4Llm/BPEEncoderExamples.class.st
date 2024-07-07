Class {
	#name : #BPEEncoderExamples,
	#superclass : #Object,
	#category : #'Gt4Llm-Tokenizer - Examples'
}

{ #category : #accessing }
BPEEncoderExamples >> encodedLorem [
	<gtExample>
	| encoder encoded |
	encoder := GtBPEEncoder new.
	encoded := encoder encode: String loremIpsum.
	
	self assert: encoded output size equals: 300.
	self assert: encoded compressionRatio > 1.
	
	^ encoded
]

{ #category : #accessing }
BPEEncoderExamples >> preTrainedEncoderLorem [
	<gtExample>
	| encoder encoded |
	encoder := GtPretrainedEncoder new merges: self encodedLorem merges.
	encoded := encoder encode: String loremIpsum.
	
	self assert: encoded size equals: 300.
	self assert: (encoder decode: encoded) equals: String loremIpsum.
	
	^ encoded
]
