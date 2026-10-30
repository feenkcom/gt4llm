"
Local stencil for displaying a GemStone Smalltalk code evaluation result. Shows a GemStone snippet coder with the evaluated source code (on the same session) and below it an inspector on the remote result object proxy.
"
Class {
	#name : #GtLSmalltalkCodeEvaluationResultGemStoneStencil,
	#superclass : #BrStencil,
	#instVars : [
		'code',
		'objectProxy',
		'bindings'
	],
	#category : #'Gt4LlmCore-Stencils'
}

{ #category : #'api - instantiation' }
GtLSmalltalkCodeEvaluationResultGemStoneStencil >> create [
	| container coderModel coderViewModel sessionLocator pharoBindings |

	container := BrVerticalPane new.
	container matchParent
		addAptitude: (BrLayoutResizerAptitude new common: [ container children ]);
		background: BrGlamorousColors backdropColor.

	coderModel := GtGemStoneSnippetCoderModel new
		sourceCode: (GtCoderExplicitStringSource new source: code).
	coderViewModel := coderModel asCoderViewModel.

	pharoBindings := GtSharedVariablesBindings new.
	bindings ifNotNil: [
		bindings keysAndValuesDo: [ :name :proxyValue |
			(pharoBindings bindingOf: name) value: proxyValue ] ].
	coderViewModel pharoBindings: pharoBindings.

	sessionLocator := nil.
	(objectProxy notNil and: [ objectProxy isGtBareProxyObject ])
		ifTrue: [
			objectProxy proxyObject gtSession ifNotNil: [ :aSession |
				sessionLocator := GtGemStoneSessionLocator new
					registry: aSession registry;
					identifier: (GtGemStoneExplicitSessionIdentifier sessionName: aSession name) ] ].
	sessionLocator ifNil: [
		GtGemStoneSessionRegistry default sessions
			detect: [ :s | s isRunning ]
			ifFound: [ :aSession |
				sessionLocator := GtGemStoneSessionLocator new
					registry: aSession registry;
					identifier: (GtGemStoneExplicitSessionIdentifier sessionName: aSession name) ] ].
	sessionLocator ifNotNil: [
		coderViewModel sessionLocator: sessionLocator ].

	container
		addChild: (coderViewModel asExpandedOnlyElement
			margin: (BlInsets all: 10);
			background: Color white;
			addAptitude: BrShadowAptitude;
			vFitContentLimited);
		addChild: (objectProxy gtDefaultInspectorTool asElement
			margin: (BlInsets all: 10);
			background: Color white;
			addAptitude: BrShadowAptitude;
			vFitContentLimited;
			hMatchParent).

	^ container
]

{ #category : #accessing }
GtLSmalltalkCodeEvaluationResultGemStoneStencil >> stencilData [

	^ Dictionary new
		at: #code put: code;
		at: #object put: objectProxy;
		at: #bindings put: bindings;
		yourself
]

{ #category : #accessing }
GtLSmalltalkCodeEvaluationResultGemStoneStencil >> stencilData: aDictionary [

	code := aDictionary at: #code.
	objectProxy := (aDictionary at: #object) asGtBareProxyObject.
	bindings := Dictionary new.
	(aDictionary at: #bindings ifAbsent: [ nil ]) ifNotNil: [ :b |
		b keysAndValuesDo: [ :k :v |
			bindings at: k put: v asGtBareProxyObject ] ]
]
