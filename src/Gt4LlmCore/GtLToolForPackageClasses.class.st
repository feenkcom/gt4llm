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
	| argument packageName organizer package classNames |
	argument := aToolCall anyArgument.
	packageName := argument ifNotNil: [ argument asString ].
	organizer := PackageOrganizer packageOrganizer.
	package := packageName
		ifNil: [ nil ]
		ifNotNil: [ organizer
			packageNamed: packageName asSymbol
			ifAbsent: [ nil ] ].
	^ package
		ifNil: [ 'Package not found' ]
		ifNotNil: [ :aPackage |
			classNames := aPackage classes collect: [ :each | each name asString ].
			classNames isEmpty
				ifTrue: [ 'No classes found' ]
				ifFalse: [ Character cr join: classNames ] ]
]
