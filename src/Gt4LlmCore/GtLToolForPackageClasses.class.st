Class {
	#name : #GtLToolForPackageClasses,
	#superclass : #GtLAbstractFunctionTool,
	#category : #Gt4LlmCore
}

{ #category : #accessing }
GtLToolForPackageClasses class >> leJsonV4Name [
	^ #gtLToolForPackageClasses
]

{ #category : #visiting }
GtLToolForPackageClasses >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForPackageClasses: self
]

{ #category : #accessing }
GtLToolForPackageClasses >> description [
	^ 'Retrieve all classes defined or extended in the given package'
]

{ #category : #accessing }
GtLToolForPackageClasses >> name [
	^ 'packageClasses'
]

{ #category : #accessing }
GtLToolForPackageClasses >> parameters [
	^ #('packageName')
]

{ #category : #private }
GtLToolForPackageClasses >> privatePerformToolCall: aToolCall [
	| argument packageName organizer package |
	argument := aToolCall anyArgument.
	packageName := argument ifNotNil: [ argument asString ].
	packageName
		ifNil: [ ^ GtLMissingArgumentDomainObject new
				receiverName: self name;
				arguments: aToolCall arguments;
				missingArgument: 'packageName' ].
	organizer := PackageOrganizer packageOrganizer.
	package := organizer
			packageNamed: packageName asSymbol
			ifAbsent: [ ^ GtLMissingDomainObject new objectName: packageName ].

	^ GtLClassesDomainObject new foundClasses: package classes
]
