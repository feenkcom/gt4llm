"
I hold what the refactoring tools list of the changes in their responses: whether code is included (includeSources, false by default) and how many entries of each group of changes are listed (classesLimit, methodsLimit, snippetsLimit). The tools take me as their optional displayOptions argument; my Magritte descriptions document my fields in the JSON schema of the tools, which checks their values before a tool runs. The reports ({{gtClass:GtLRefactoringReport}}) are built with me; the previews and results they report on do not know me.

{{gtMethod:GtLRefactoringDisplayOptions class>>#fromArguments:}} reads me from the arguments of a tool call. {{gtClass:GtLRefactoringResultDisplayOptions}} adds includeChanges for the tools that apply a refactoring; {{gtClass:GtLRewriteDisplayOptions}} includes the sources by default and lists only methods; {{gtClass:GtLRefactoringChangesOptions}} lists the groups asked for, each from its offset.
"
Class {
	#name : #GtLRefactoringDisplayOptions,
	#superclass : #Object,
	#instVars : [
		'includeSources',
		'classesLimit',
		'methodsLimit',
		'snippetsLimit'
	],
	#category : #'Gt4LlmCore-Refactorings'
}

{ #category : #accessing }
GtLRefactoringDisplayOptions class >> defaultIncludeSources [
	"Sources make responses large: they are left out unless asked for"

	^ false
]

{ #category : #accessing }
GtLRefactoringDisplayOptions class >> defaultLimit [
	^ 200
]

{ #category : #'instance creation' }
GtLRefactoringDisplayOptions class >> fromArguments: aDictionary [
	"Return the options in the displayOptions argument of a tool call, already read as an instance of my class and checked by the JSON schema, or the default options when it is absent"

	^ aDictionary at: 'displayOptions' ifAbsent: [ self new ]
]

{ #category : #accessing }
GtLRefactoringDisplayOptions class >> maximumLimit [
	^ 5000
]

{ #category : #accessing }
GtLRefactoringDisplayOptions class >> normalizedLimit: aNumberOrNil [
	"Absent limits have the default value; limits above the maximum are lowered to the maximum.
	JSON numbers can be read as floats"

	aNumberOrNil ifNil: [ ^ self defaultLimit ].
	^ aNumberOrNil truncated min: self maximumLimit
]

{ #category : #accessing }
GtLRefactoringDisplayOptions >> classesLimit [
	^ self class normalizedLimit: classesLimit
]

{ #category : #accessing }
GtLRefactoringDisplayOptions >> classesLimit: anIntegerOrNil [
	classesLimit := anIntegerOrNil
]

{ #category : #descriptions }
GtLRefactoringDisplayOptions >> classesLimitDescription [
	<magritteDescription>
	^ self
		limitDescriptionLabeled: 'Classes limit'
		accessor: #classesLimit
		of: 'changed classes to list'
]

{ #category : #descriptions }
GtLRefactoringDisplayOptions >> descriptionContainer [
	^ super descriptionContainer
		comment: 'How much of the previewed changes the response lists. The limits apply to the groups; a changes list is listed whole.';
		yourself
]

{ #category : #accessing }
GtLRefactoringDisplayOptions >> displayOptionItems [
	"Return my options as name -> value, as the tools take them"

	^ {'includeSources' -> self includeSources.
		'classesLimit' -> self classesLimit.
		'methodsLimit' -> self methodsLimit.
		'snippetsLimit' -> self snippetsLimit}
]

{ #category : #accessing }
GtLRefactoringDisplayOptions >> includeSources [
	^ includeSources ifNil: [ self class defaultIncludeSources ]
]

{ #category : #accessing }
GtLRefactoringDisplayOptions >> includeSources: aBooleanOrNil [
	includeSources := aBooleanOrNil
]

{ #category : #descriptions }
GtLRefactoringDisplayOptions >> includeSourcesDescription [
	<magritteDescription>
	^ MABooleanDescription new
		label: 'Include sources';
		accessor: #includeSources;
		comment: 'Whether the listed changes have their newSource: the method source, class definition, class comment or snippet text. Defaults to '
				, self class defaultIncludeSources printString , '.';
		beOptional
]

{ #category : #descriptions }
GtLRefactoringDisplayOptions >> limitDescriptionLabeled: aLabel accessor: aSelector of: aString [
	^ MANumberDescription new
		label: aLabel;
		accessor: aSelector;
		comment: 'The maximum number of ' , aString , '. Defaults to '
				, self class defaultLimit printString , ', at most '
				, self class maximumLimit printString , '; 0 gives only the counts.';
		beIntegerInJsonSchema;
		min: 0;
		beOptional
]

{ #category : #accessing }
GtLRefactoringDisplayOptions >> limitOfGroup: aGroupName [
	"Other changes, such as package changes, are rare: they are all listed"

	aGroupName = 'classChanges' ifTrue: [ ^ self classesLimit ].
	aGroupName = 'methodChanges' ifTrue: [ ^ self methodsLimit ].
	aGroupName = 'lepiterChanges' ifTrue: [ ^ self snippetsLimit ].
	^ self class maximumLimit
]

{ #category : #testing }
GtLRefactoringDisplayOptions >> listsGroup: aGroupName [
	"The responses of the refactoring tools list all the groups of a refactoring"

	^ true
]

{ #category : #accessing }
GtLRefactoringDisplayOptions >> methodsLimit [
	^ self class normalizedLimit: methodsLimit
]

{ #category : #accessing }
GtLRefactoringDisplayOptions >> methodsLimit: anIntegerOrNil [
	methodsLimit := anIntegerOrNil
]

{ #category : #descriptions }
GtLRefactoringDisplayOptions >> methodsLimitDescription [
	<magritteDescription>
	^ self
		limitDescriptionLabeled: 'Methods limit'
		accessor: #methodsLimit
		of: 'changed methods to list'
]

{ #category : #accessing }
GtLRefactoringDisplayOptions >> offsetOfGroup: aGroupName [
	"The responses of the refactoring tools list each group from its first change"

	^ 0
]

{ #category : #printing }
GtLRefactoringDisplayOptions >> printOn: aStream [
	super printOn: aStream.
	aStream parenthesize: [ self printOptionsOn: aStream ]
]

{ #category : #printing }
GtLRefactoringDisplayOptions >> printOptionsOn: aStream [
	aStream
		nextPutAll: 'sources: ';
		print: self includeSources;
		nextPutAll: ', limits: ';
		print: self classesLimit;
		nextPut: $/;
		print: self methodsLimit;
		nextPut: $/;
		print: self snippetsLimit
]

{ #category : #testing }
GtLRefactoringDisplayOptions >> requestsGroup: aGroupName [
	"Whether the group was asked for explicitly, so that it is listed also when it is empty"

	^ false
]

{ #category : #accessing }
GtLRefactoringDisplayOptions >> snippetsLimit [
	^ self class normalizedLimit: snippetsLimit
]

{ #category : #accessing }
GtLRefactoringDisplayOptions >> snippetsLimit: anIntegerOrNil [
	snippetsLimit := anIntegerOrNil
]

{ #category : #descriptions }
GtLRefactoringDisplayOptions >> snippetsLimitDescription [
	<magritteDescription>
	^ self
		limitDescriptionLabeled: 'Snippets limit'
		accessor: #snippetsLimit
		of: 'changed Lepiter snippets to list, counted one by one across databases and pages'
]
