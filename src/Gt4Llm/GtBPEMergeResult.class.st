Class {
	#name : #GtBPEMergeResult,
	#superclass : #Object,
	#instVars : [
		'merges',
		'output'
	],
	#category : #'Gt4Llm-Tokenizer'
}

{ #category : #accessing }
GtBPEMergeResult >> merges [
	^ merges
]

{ #category : #accessing }
GtBPEMergeResult >> merges: anObject [
	merges := anObject
]

{ #category : #accessing }
GtBPEMergeResult >> output [
	^ output
]

{ #category : #accessing }
GtBPEMergeResult >> output: anObject [
	output := anObject
]
