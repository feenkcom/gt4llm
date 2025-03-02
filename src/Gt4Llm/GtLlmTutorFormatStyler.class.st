Class {
	#name : #GtLlmTutorFormatStyler,
	#superclass : #GtGenericPharoStyler,
	#instVars : [
		'formatReferences'
	],
	#category : #Gt4Llm
}

{ #category : #accessing }
GtLlmTutorFormatStyler >> formatReferences [
	^ formatReferences
]

{ #category : #accessing }
GtLlmTutorFormatStyler >> formatReferences: anObject [
	formatReferences := (anObject
			collect: [ :aReference | aReference name -> aReference ]) asDictionary
]

{ #category : #'as yet unclassified' }
GtLlmTutorFormatStyler >> tutor: aTutor [
	self formatReferences: aTutor formatComponents
]

{ #category : #'as yet unclassified' }
GtLlmTutorFormatStyler >> visitStringLiteral: aStringLiteralNode [
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
