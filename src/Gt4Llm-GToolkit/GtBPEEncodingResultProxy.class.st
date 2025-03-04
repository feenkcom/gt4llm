Class {
	#name : #GtBPEEncodingResultProxy,
	#superclass : #PBProxyObject,
	#category : #'Gt4Llm-GToolkit'
}

{ #category : #accessing }
GtBPEEncodingResultProxy class >> pythonClass [
	^ 'tokenization.EncodingResult'
]

{ #category : #accessing }
GtBPEEncodingResultProxy >> gtTokenizedFor: aView [
	<gtView>
	^ aView explicit
		title: 'Tokenized';
		priority: 0;
		stencil: [ GtLlmTokenizedStringEditor new result: self ]
]

{ #category : #accessing }
GtBPEEncodingResultProxy >> tokens [
	^ self ids
]
