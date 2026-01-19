Class {
	#name : #GtLToolForPackageClassesExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Tools'
}

{ #category : #examples }
GtLToolForPackageClassesExamples >> packageClassesForExistingPackage [
	<gtExample>
	| tool call result |
	tool := GtLToolForPackageClasses new.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'packageName' -> 'Gt4LlmCore'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result isEmpty not.
	self assert: (result includesSubstring: 'GtLToolForPackageClasses').
	^ tool
]

{ #category : #examples }
GtLToolForPackageClassesExamples >> packageClassesForPackageWithNoClasses [
	<gtExample>
	| tool call result organizer packageName package existed |
	tool := GtLToolForPackageClasses new.
	organizer := PackageOrganizer packageOrganizer.
	packageName := 'EmptyPackageWithNoClasses'.
	existed := organizer includesPackageNamed: packageName asSymbol.
	package := existed
		ifTrue: [ organizer packageNamed: packageName asSymbol ]
		ifFalse: [ organizer addPackage: packageName ].
	[
		call := GtLFunctionToolCall new.
		call function: {
			'name' -> tool name.
			'arguments' -> {'packageName' -> packageName} asDictionary
		} asDictionary.
		result := tool performToolCall: call.
		self assert: call tool == tool.
		self assert: result equals: 'No classes found'
	] ensure: [
		existed ifFalse: [ organizer unregisterPackage: package ]
	].
	^ tool
]

{ #category : #examples }
GtLToolForPackageClassesExamples >> packageClassesForUnknownPackage [
	<gtExample>
	| tool call result |
	tool := GtLToolForPackageClasses new.
	call := GtLFunctionToolCall new.
	call function: {
		'name' -> tool name.
		'arguments' -> {'packageName' -> 'NonExistingPackageName42'} asDictionary
	} asDictionary.
	result := tool performToolCall: call.
	self assert: call tool == tool.
	self assert: result equals: 'Package not found'.
	^ tool
]
