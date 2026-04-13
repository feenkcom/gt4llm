Class {
	#name : #GtLSmaCCTransformationTool,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#instVars : [
		'model'
	],
	#category : #'Gt4Llm-SmaCC-Transformations-Tools'
}

{ #category : #initialization }
GtLSmaCCTransformationTool >> initialize [
	super initialize.
	model := GtLSmaCCTransformationModel new
]

{ #category : #accessing }
GtLSmaCCTransformationTool >> model [
	^ model
]

{ #category : #accessing }
GtLSmaCCTransformationTool >> model: anObject [
	model := anObject
]
