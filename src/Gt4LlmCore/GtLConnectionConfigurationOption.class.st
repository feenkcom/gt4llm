Class {
	#name : #GtLConnectionConfigurationOption,
	#superclass : #Object,
	#instVars : [
		'name'
	],
	#category : #'Gt4LlmCore-Core'
}

{ #category : #api }
GtLConnectionConfigurationOption >> applyOn: aProvider [

	self subclassResponsibility
]

{ #category : #accessing }
GtLConnectionConfigurationOption >> name [
	^ name
]

{ #category : #accessing }
GtLConnectionConfigurationOption >> name: aString [

	name := aString
]
