Class {
	#name : #GtLConnectionPropertyConfigurationOption,
	#superclass : #GtLConnectionConfigurationOption,
	#instVars : [
		'selector',
		'valueGenerator'
	],
	#category : #'Gt4LlmCore-Core'
}

{ #category : #'instance creation' }
GtLConnectionPropertyConfigurationOption class >> name: aString selector: aSymbol valueGenerator: aValuable [

	^ self new
		name: aString;
		selector: aSymbol;
		valueGenerator: aValuable
]

{ #category : #api }
GtLConnectionPropertyConfigurationOption >> applyOn: aProvider [

	aProvider
		perform: selector
		withArguments: self values
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
			self values
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
GtLConnectionPropertyConfigurationOption >> valueGenerator [
	"Set the valueGenerator to an object that answers the array of arguments when sent #value"
	
	^ valueGenerator
]

{ #category : #accessing }
GtLConnectionPropertyConfigurationOption >> valueGenerator: aValuable [
	"Set the valueGenerator to an object that answers the array of arguments when sent #value"

	valueGenerator := aValuable
]

{ #category : #accessing }
GtLConnectionPropertyConfigurationOption >> values [
	^ valueGenerator value
]
