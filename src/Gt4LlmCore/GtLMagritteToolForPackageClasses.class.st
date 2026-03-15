"
Magritte-based tool for retrieving package classes.
"
Class {
	#name : #GtLMagritteToolForPackageClasses,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLMagritteToolForPackageClasses >> description [
	^ 'Retrieve all classes defined or extended in the given package.

Arguments:
- packageName: string

Return values:
- foundClassNames: array of class names as strings
- mayHaveMore: boolean indicating if there are more matches than returned

Example JSON arguments:
{
  "packageName": "Bloc"
}

Example JSON response:
{
  "foundClassNames": ["BlElement", "BlSpace"],
  "mayHaveMore": true
}'
]

{ #category : #accessing }
GtLMagritteToolForPackageClasses >> name [
	^ 'packageClasses'
]

{ #category : #accessing }
GtLMagritteToolForPackageClasses >> packageNameDescription [
	<magritteDescription>

	^ MAStringDescription new
		label: 'Package name';
		accessor: #packageName;
		beRequired
]

{ #category : #private }
GtLMagritteToolForPackageClasses >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	| arguments packageName organizer package |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	packageName := arguments at: 'packageName'.

	(packageName trimBoth isEmpty)
		ifTrue: [ ^ GtLMissingArgumentDomainObject new
				arguments: arguments;
				missingArgument: 'packageName' ].

	organizer := PackageOrganizer packageOrganizer.
	package := organizer
		packageNamed: packageName asSymbol
		ifAbsent: [ ^ GtLMissingDomainObject new objectName: packageName ].

	^ GtLClassesSearchResult fromClasses: package classes
]
