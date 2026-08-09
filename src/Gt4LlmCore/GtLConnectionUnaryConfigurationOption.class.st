Class {
	#name : #GtLConnectionUnaryConfigurationOption,
	#superclass : #GtLConnectionConfigurationOption,
	#instVars : [
		'selector'
	],
	#category : #'Gt4LlmCore-Core'
}

{ #category : #'instance creation' }
GtLConnectionUnaryConfigurationOption class >> name: aString selector: aSymbol [

	^ self new
		name: aString;
		selector: aSymbol
]

{ #category : #api }
GtLConnectionUnaryConfigurationOption >> applyOn: aProvider [

	aProvider perform: selector
]

{ #category : #printing }
GtLConnectionUnaryConfigurationOption >> gtDisplayOn: aStream [

	aStream
		<< name asString;
		<< '(';
		<< selector asString;
		<< ')'.
]

{ #category : #accessing }
GtLConnectionUnaryConfigurationOption >> selector [
	^ selector
]

{ #category : #accessing }
GtLConnectionUnaryConfigurationOption >> selector: anObject [
	selector := anObject
]
