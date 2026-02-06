Class {
	#name : #GtBPEDemoEncodingResultProxy,
	#superclass : #PBProxyObject,
	#category : 'Gt4Llm-GToolkit-BPE'
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
		priority: 0;
		stencil: [ GtLlmTokenizedStringEditor new result: self ]
]

{ #category : #accessing }
GtBPEDemoEncodingResultProxy >> tokens [
	^ self ids
]
