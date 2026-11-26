"
I show how the refactoring tools read and validate their displayOptions argument ({{gtClass:GtLRefactoringDisplayOptions}} and its subclasses), and their defaults.
"
Class {
	#name : #GtLRefactoringDisplayOptionsExamples,
	#superclass : #GtLDomainObjectExamples,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #examples }
GtLRefactoringDisplayOptionsExamples >> defaultDisplayOptions [
	"Absent displayOptions give the defaults: no sources, and 200 entries per group. Only the options of the tools that apply a refactoring have includeChanges"

	<gtExample>
	| options |
	options := GtLRefactoringDisplayOptions
			fromArguments: {'objectId' -> 'abc123'} asDictionary.
	self assert: options class equals: GtLRefactoringDisplayOptions.
	self assert: options includeSources not.
	self assert: (options respondsTo: #includeChanges) not.
	self
		assert: options classesLimit
		equals: GtLRefactoringDisplayOptions defaultLimit.
	self assert: options methodsLimit equals: 200.
	self assert: options snippetsLimit equals: 200.
	self assert: GtLRefactoringResultDisplayOptions new includeChanges.
	self
		assert: (GtLRefactoringResultDisplayOptions new printString
				includesSubstring: '(sources: false, limits: 200/200/200, changes: true)').
	^ options
]

{ #category : #examples }
GtLRefactoringDisplayOptionsExamples >> displayOptionsFromArguments [
	"The tool reads the displayOptions argument as an instance of the options class; absent fields keep their defaults"

	<gtExample>
	| options |
	options := self
			optionsFrom: '{"objectId": "abc123", "displayOptions": {"includeSources": false, "includeChanges": false, "methodsLimit": 3, "snippetsLimit": 0}}'
			with: GtLToolForApplyRefactoring new.
	self assert: options class equals: GtLRefactoringResultDisplayOptions.
	self assert: options includeSources not.
	self assert: options includeChanges not.
	self assert: options classesLimit equals: 200.
	self assert: options methodsLimit equals: 3.
	self assert: options snippetsLimit equals: 0.
	^ options
]

{ #category : #examples }
GtLRefactoringDisplayOptionsExamples >> displayOptionsOfAPreview [
	<gtExample>
	| options |
	options := self
			optionsFrom: '{"transformations": [], "displayOptions": {"classesLimit": 1}}'
			with: GtLToolForPreviewRefactoring new.
	self assert: options class equals: GtLRefactoringDisplayOptions.
	self assert: options classesLimit equals: 1.
	self assert: options includeSources not.
	^ options
]

{ #category : #examples }
GtLRefactoringDisplayOptionsExamples >> displayOptionsSchemas [
	"The options are documented by the schema of the displayOptions argument; only the tools that apply a refactoring have includeChanges"

	<gtExample>
	| previewSchema applySchema |
	previewSchema := (GtLToolForPreviewRefactoring new parametersDescription schema
			json at: 'properties') at: 'displayOptions'.
	applySchema := (GtLToolForApplyRefactoring new parametersDescription schema
			json at: 'properties') at: 'displayOptions'.
	self assert: (previewSchema at: 'type') equals: 'object'.
	self assert: (previewSchema at: 'description') notEmpty.
	self
		assert: (previewSchema at: 'properties') keys asSet
		equals: #('includeSources' 'classesLimit' 'methodsLimit' 'snippetsLimit') asSet.
	self
		assert: (applySchema at: 'properties') keys asSet
		equals: #('includeChanges' 'includeSources' 'classesLimit' 'methodsLimit' 'snippetsLimit')
				asSet.
	self assert: (previewSchema at: 'required') isEmpty.
	self
		assert: (((GtLMagritteToolForClassRename new parametersDescription schema json
				at: 'properties') at: 'displayOptions') at: 'properties') keys asSet
		equals: (applySchema at: 'properties') keys asSet.
	^ applySchema
]

{ #category : #examples }
GtLRefactoringDisplayOptionsExamples >> integralFloatLimit [
	"JSON numbers can be read as floats; the JSON schema accepts integral ones as integers"

	<gtExample>
	| options |
	options := GtLRefactoringDisplayOptions new snippetsLimit: 4.0.
	self assert: options snippetsLimit equals: 4.
	self assert: options snippetsLimit isInteger.
	self
		assert: (self
				schemaErrorsOf: {'transformations' -> #().
						'displayOptions' -> {'snippetsLimit' -> 4.0} asDictionary} asDictionary
				for: GtLToolForPreviewRefactoring new) isEmpty.
	^ options
]

{ #category : #examples }
GtLRefactoringDisplayOptionsExamples >> limitAboveMaximumIsLowered [
	<gtExample>
	| options |
	options := GtLRefactoringDisplayOptions new methodsLimit: 100000.
	self
		assert: options methodsLimit
		equals: GtLRefactoringDisplayOptions maximumLimit.
	self assert: options methodsLimit equals: 5000.
	^ options
]

{ #category : #private }
GtLRefactoringDisplayOptionsExamples >> optionsFrom: aJsonString with: aTool [
	"Read the displayOptions argument as the tool reads its arguments"

	| arguments |
	arguments := aTool parametersDescription
			readGenericDomainObjectsFrom: aJsonString.
	^ ((aTool isKindOf: GtLToolForApplyRefactoring)
		ifTrue: [ GtLRefactoringResultDisplayOptions ]
		ifFalse: [ GtLRefactoringDisplayOptions ]) fromArguments: arguments
]

{ #category : #examples }
GtLRefactoringDisplayOptionsExamples >> rewriteDisplayOptionsIncludeSources [
	"A rewrite is reviewed through the new sources of the rewritten methods: they are listed unless asked otherwise"

	<gtExample>
	| options schema description |
	options := self
			optionsFrom: '{"from": "a", "to": "b", "isMethodPattern": false, "className": "", "packageName": "", "displayOptions": {"methodsLimit": 5}}'
			with: GtLToolForPreviewRewrite new.
	self assert: options class equals: GtLRewriteDisplayOptions.
	self assert: options includeSources.
	self assert: options methodsLimit equals: 5.
	self
		assert: (GtLRewriteDisplayOptions new includeSources: false) includeSources not.
	schema := (GtLToolForPreviewRewrite new parametersDescription schema json
			at: 'properties') at: 'displayOptions'.
	description := ((schema at: 'properties') at: 'includeSources')
			at: 'description'.
	self assert: (description endsWith: 'Defaults to true.').
	^ options
]

{ #category : #private }
GtLRefactoringDisplayOptionsExamples >> schemaErrorsOf: aDictionary for: aTool [
	"Return the messages of the JSON schema errors of the arguments of a call to the tool"

	| call |
	call := GtLFunctionToolCall new.
	call rawArguments: aDictionary.
	^ (aTool jsonSchemaArgumentValidationErrorsFor: call)
		collect: [ :each | each errorMessage ]
]

{ #category : #examples }
GtLRefactoringDisplayOptionsExamples >> schemaRefusesInvalidOptions [
	"The JSON schema of the tool checks the options before the tool runs: limits are non-negative integers and flags booleans"

	<gtExample>
	| tool errors |
	tool := GtLToolForApplyRefactoring new.
	errors := {{'methodsLimit' -> -1}.
			{'classesLimit' -> 2.5}.
			{'snippetsLimit' -> 'ten'}.
			{'includeChanges' -> 'no'}.
			{'includeSources' -> 1}}
			collect: [ :someOptions | 
				(self
					schemaErrorsOf: {'objectId' -> 'abc123'.
							'displayOptions' -> someOptions asDictionary} asDictionary
					for: tool) first ].
	self
		assert: errors
		equals: #('@[displayOptions/methodsLimit] smaller than minimum [0]' '@[displayOptions/classesLimit] integer expected' '@[displayOptions/snippetsLimit] integer expected' '@[displayOptions/includeChanges] boolean expected' '@[displayOptions/includeSources] boolean expected').
	self
		assert: (self
				schemaErrorsOf: {'objectId' -> 'abc123'.
						'displayOptions' -> 'all'} asDictionary
				for: tool) first
		equals: '@[displayOptions] object expected'.
	^ errors
]
