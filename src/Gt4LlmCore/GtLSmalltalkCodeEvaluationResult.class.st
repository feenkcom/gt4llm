"
Represents the successful result of a Smalltalk code evaluation with the code, serialized object value, and optional object ID.
"
Class {
	#name : #GtLSmalltalkCodeEvaluationResult,
	#superclass : #GtLObjectStorageValueResult,
	#instVars : [
		'code',
		'bindings'
	],
	#category : #'Gt4LlmCore-Domain Objects'
}

{ #category : #'as yet unclassified' }
GtLSmalltalkCodeEvaluationResult class >> forObject: anObject withId: anId andCode: aString [
	^ self forObject: anObject withId: anId code: aString playgroundPageReference: nil
]

{ #category : #'as yet unclassified' }
GtLSmalltalkCodeEvaluationResult class >> forObject: anObject withId: anId code: aString playgroundPageReference: aLepiterPageReference [
	^ (self forObject: anObject withId: anId) 
			code: aString;
			playgroundPageReference: aLepiterPageReference
]

{ #category : #accessing }
GtLSmalltalkCodeEvaluationResult >> bindings [
	^ bindings
]

{ #category : #accessing }
GtLSmalltalkCodeEvaluationResult >> bindings: aDictionary [
	bindings := aDictionary
]

{ #category : #accessing }
GtLSmalltalkCodeEvaluationResult >> code [
	^ code
]

{ #category : #accessing }
GtLSmalltalkCodeEvaluationResult >> code: aString [
	code := aString
]

{ #category : #descriptions }
GtLSmalltalkCodeEvaluationResult >> codeDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Code';
		accessor: #code;
		beRequired
]

{ #category : #'gt - extensions' }
GtLSmalltalkCodeEvaluationResult >> gtCodeFor: aView [
	<gtView>
	<gtLlmView>
	^ self
		gtDo: [ aView explicit
				title: 'Code and object';
				priority: 9;
				stencil: [ | container |
					container := BrVerticalPane new.
					container matchParent
						addAptitude: (BrLayoutResizerAptitude new common: [ container children ]);
						background: BrGlamorousColors backdropColor;
						addChild: ((GtPharoSnippetCoder new
								forSource: self code;
								subscribeToSystem;
								asExpandedOnlyElement)
								margin: (BlInsets all: 10);
								background: Color white;
								addAptitude: BrShadowAptitude;
								vFitContentLimited);
						addChild: (object gtDefaultInspectorTool asElement
								margin: (BlInsets all: 10);
								background: Color white;
								addAptitude: BrShadowAptitude;
								vFitContentLimited;
								hMatchParent) ] ]
		gemstoneDo: [ | stencilBindings stencilData |
			stencilBindings := Dictionary new.
			bindings ifNotNil: [
				bindings keysAndValuesDo: [ :k :v |
					stencilBindings at: k put: (GtRsrProxyServiceServer object: v) ] ].
			stencilData := Dictionary new
				at: #code put: self code;
				at: #object put: (GtRsrProxyServiceServer object: object);
				yourself.
			stencilBindings ifNotEmpty: [
				stencilData at: #bindings put: stencilBindings ].
			aView explicit
				title: 'Code and object';
				priority: 9;
				declarativeStencil: [
					GtPhlowNamedStencil new
						stencilClassName: #GtLSmalltalkCodeEvaluationResultGemStoneStencil;
						stencilData: stencilData;
						dataSerializationStrategy: GtPhlowStencilDataSerializationStrategy
							forMixedProxyDataEncoding ] ]
]

{ #category : #printing }
GtLSmalltalkCodeEvaluationResult >> printOn: aStream [
	super printOn: aStream.
	
	aStream nextPutAll: ' code: '; nextPutAll: self code
]
