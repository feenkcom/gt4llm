Class {
	#name : #GtLConnectionPropertyConfigurationOption,
	#superclass : #GtLConnectionConfigurationOption,
	#instVars : [
		'selector',
		'values'
	],
	#category : #'Gt4LlmCore-Core'
}

{ #category : #'instance creation' }
GtLConnectionPropertyConfigurationOption class >> name: aString selector: aSymbol values: anArray [

	^ self new
		name: aString;
		selector: aSymbol;
		values: anArray
]

{ #category : #api }
GtLConnectionPropertyConfigurationOption >> applyOn: aProvider [

	aProvider
		perform: selector
		withArguments: values
]

{ #category : #printing }
GtLConnectionPropertyConfigurationOption >> gtDisplayOn: aStream [

	aStream
		<< name asString;
		space;
		parenthesize: [ 
			aStream
				<< selector asString;
				space.
			values
				do: [ :value | aStream << value asString ]
				separatedBy: [ aStream << ', ' ] ].
]

{ #category : #accessing }
GtLConnectionPropertyConfigurationOption >> selector [
	^ selector
]

{ #category : #accessing }
GtLConnectionPropertyConfigurationOption >> selector: aSymbol [

	selector := aSymbol
]

{ #category : #accessing }
GtLConnectionPropertyConfigurationOption >> values [
	^ values
]

{ #category : #accessing }
GtLConnectionPropertyConfigurationOption >> values: anArray [

	values := anArray
]
