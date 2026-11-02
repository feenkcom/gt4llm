"
Local stencil for displaying a GemStone object value result. Shows an inspector on the remote result object proxy.
"
Class {
	#name : #GtLObjectValueResultGemStoneStencil,
	#superclass : #BrStencil,
	#instVars : [
		'objectProxy'
	],
	#category : #'Gt4LlmCore-Stencils'
}

{ #category : #'api - instantiation' }
GtLObjectValueResultGemStoneStencil >> create [
	| container sessionLocator |

	container := BrVerticalPane new.
	container matchParent
		addAptitude: (BrLayoutResizerAptitude new common: [ container children ]);
		background: BrGlamorousColors backdropColor;
		addChild: (objectProxy gtDefaultInspectorTool asElement
			margin: (BlInsets all: 10);
			background: Color white;
			addAptitude: BrShadowAptitude;
			vFitContentLimited;
			hMatchParent).

	^ container
]

{ #category : #accessing }
GtLObjectValueResultGemStoneStencil >> stencilData [

	^ { #object -> objectProxy } asDictionary
]

{ #category : #accessing }
GtLObjectValueResultGemStoneStencil >> stencilData: aDictionary [

	objectProxy := (aDictionary at: #object) asGtBareProxyObject
]
