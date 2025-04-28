Class {
	#name : #GtLlmAssistantFormatStyler,
	#superclass : #GtGenericPharoStyler,
	#instVars : [
		'formatReferences'
	],
	#category : #'Gt4Llm-GToolkit'
}

{ #category : #'as yet unclassified' }
GtLlmAssistantFormatStyler >> assistant: anAssistant [
	self formatReferences: anAssistant formatComponents
]

{ #category : #accessing }
GtLlmAssistantFormatStyler >> formatReferences [
	^ formatReferences
]

{ #category : #accessing }
GtLlmAssistantFormatStyler >> formatReferences: anObject [
	formatReferences := (anObject
			collect: [ :aReference | aReference name -> aReference ]) asDictionary
]

{ #category : #'as yet unclassified' }
GtLlmAssistantFormatStyler >> visitStringLiteral: aStringLiteralNode [
	super visitStringLiteral: aStringLiteralNode.

	(self formatReferences includesKey: aStringLiteralNode string)
		ifTrue: [ | anExpanderAttribute |
			anExpanderAttribute := BrGlamorousTriangleExpanderTextAttribute new
					id: GtSourceCoderEmbeddedExpanderToggleId;
					attributesCreatingBlock: [ BrTextAdornmentDynamicAttribute new
							beAppend;
							stencil: [ ((GtPharoMethodCoder
									forMethod: (self formatReferences at: aStringLiteralNode string) definingMethod)
									asCoderViewModel expanded: true) asElement ] ].

			self
				attribute: anExpanderAttribute
				from: aStringLiteralNode value stopPosition
				to: aStringLiteralNode value stopPosition ]
]
