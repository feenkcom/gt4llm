Class {
	#name : #GtLAbstractPlainSchemaFunctionTool,
	#superclass : #GtLAbstractFunctionTool,
	#category : 'Gt4LlmCore-Tools'
}

{ #category : #testing }
GtLAbstractPlainSchemaFunctionTool class >> isAbstract [
	^ self name = #GtLAbstractPlainSchemaFunctionTool
]

{ #category : #utils }
GtLAbstractPlainSchemaFunctionTool >> computeParametersCompositeFormatFrom: anArrayOfDescriptions [
	| parametersFormat |
	
	parametersFormat := GtLResponseCompositeFormat new.
	anArrayOfDescriptions do: [ :aParameterFormatOrString | 
		| parameterFormat |
		parameterFormat := aParameterFormatOrString isString
			ifTrue: [ GtLResponseStringFormat named: aParameterFormatOrString  ] 
			ifFalse: [ aParameterFormatOrString ].
		parametersFormat addSchemaDescription: parameterFormat ].
	
	^ parametersFormat
]

{ #category : #utils }
GtLAbstractPlainSchemaFunctionTool >> computeParametersFormat [
	| parametersDescription |
	
	parametersDescription := self parametersDescription.
	^ parametersDescription isArray 
		ifTrue: [ self computeParametersCompositeFormatFrom: parametersDescription ]
		ifFalse: [ parametersDescription ].
]

{ #category : #accessing }
GtLAbstractPlainSchemaFunctionTool >> parametersDescription [
	^ self subclassResponsibility
]
