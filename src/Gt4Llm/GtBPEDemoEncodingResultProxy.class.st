Class {
	#name : #GtBPEDemoEncodingResultProxy,
	#superclass : #PBProxyObject,
	#category : #'Gt4Llm-Tokenizer'
}

{ #category : #accessing }
GtBPEDemoEncodingResultProxy class >> pythonClass [
	^ 'gtoolkit_bridge.PythonBridge.python_bridge.EncodingResult'
]

{ #category : #accessing }
GtBPEDemoEncodingResultProxy >> gtTokenizedFor: aView [
	<gtView>
	^ aView explicit
		title: 'Tokenized';
		priority: 1.5;
		stencil: [ GtLlmTokenizedStringEditor new result: self ]
]

{ #category : #accessing }
GtBPEDemoEncodingResultProxy >> tokens [
	^ self ids
]
