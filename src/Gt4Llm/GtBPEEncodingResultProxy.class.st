Class {
	#name : #GtBPEEncodingResultProxy,
	#superclass : #PBProxyObject,
	#category : #'Gt4Llm-Tokenizer'
}

{ #category : #accessing }
GtBPEEncodingResultProxy class >> pythonClass [
	^ 'gtoolkit_bridge.PythonBridge.python_bridge.EncodingResult'
]

{ #category : #accessing }
GtBPEEncodingResultProxy >> gtTokenizedFor: aView [
	<gtView>
	^ aView explicit
		title: 'Tokenized';
		priority: 1.5;
		stencil: [ GtLlmTokenizedStringEditor new result: self ]
]

{ #category : #accessing }
GtBPEEncodingResultProxy >> tokens [
	^ self ids
]
