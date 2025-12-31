Class {
	#name : #GtLToolForRemoteExampleMethodsRun,
	#superclass : #GtLAbstractFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #accessing }
GtLToolForRemoteExampleMethodsRun class >> leJsonV4Name [
	^ #gtLlmToolForRemoteExampleMethodsRun
]

{ #category : #'instance creation' }
GtLToolForRemoteExampleMethodsRun class >> openAiAssistant [
	"Answer a basic OpenAI assistant for testing the tool"
	| assistant chat |

	assistant := GtLlmAssistant new
		description: 'You are an assistant for Glamorous Toolkit'.
	assistant instruction
		replaceFormatNamed: 'Text'
		with: GtLlmAssistantLibraryForGt textFormatWithSmalltalkBlocks.
	assistant instruction
		"addComponent: GtLlmAssistantLibraryForGt codeFormatWithSnippetMethodClass."
		addComponent: GtLlmAssistantLibraryForGt changesFormatWithPageSnippetMethodClass.
	chat := assistant createChat.
	chat provider
		assistantMessageClass: GtOpenAIObjectMessage;
		userMessageClass: GtOpenAIObjectMessage.
	chat 
		addTool: GtLlmToolForClassSearch new;
		addTool: GtLlmToolForClassLookup new;
		addTool: GtLlmToolForClassSubclasses new;
		addTool: GtLlmToolForMethodImplementors new;
		addTool: GtLlmToolForMethodReferences new;
		addTool: GtLlmToolForMethodSource new;
		addTool: GtLlmToolForRemoteExampleMethodsRun new.
	^ chat.
]

{ #category : #private }
GtLToolForRemoteExampleMethodsRun >> addClass: changeDictionary to: eventFactory [
	| definitionSource classBuilder classDefinition |
	definitionSource := changeDictionary at: 'code'.
	self validateClassDefinitionSource: definitionSource.
	classBuilder := self class compiler evaluate: definitionSource.
	classBuilder class = ShiftClassBuilder
		ifFalse: [ self
				error: 'Supplied class definition evaluates to a ' , classBuilder class name asString
						, ', not a ShiftClassBuilder' ].
	classDefinition := classBuilder asRingDefinition.
	eventFactory addClass: classDefinition tags: (self tagsUsing: eventFactory)
]

{ #category : #private }
GtLToolForRemoteExampleMethodsRun >> addErrorDetails: aGtRrErrorDetails to: report [

	report at: 'taskError' put: {
		'message' -> aGtRrErrorDetails errorMessage.
		'stackTrace' -> aGtRrErrorDetails trace. }
			asDictionary.
]

{ #category : #private }
GtLToolForRemoteExampleMethodsRun >> addErrorMessage: aString to: reportDictionary [

	reportDictionary at: 'errors' put:
		(reportDictionary at: 'errors' 
			ifPresent: [ :errors | errors copyWith: aString ]
			ifAbsent: [ { aString } ])
]

{ #category : #private }
GtLToolForRemoteExampleMethodsRun >> addMethod: changeDictionary to: eventFactory [ 
	| methodClass ast methodDefinition |
	
	methodClass := self class environment classOrTraitNamed:
		(changeDictionary at: 'class').
	ast := RBParser parseMethod: (changeDictionary at: 'code').
	methodDefinition := eventFactory
		methodDefinitionSelector: ast selector
		className: methodClass name
		meta: methodClass isMeta
		package: methodClass package asRingDefinition
		protocol: 'llm-generated'
		sourceCode: ast sourceCode
		stamp: 'llm ', DateAndTime now printString.
	eventFactory 
		addMethod: methodDefinition 
		tags: (self tagsUsing: eventFactory).
]

{ #category : #private }
GtLToolForRemoteExampleMethodsRun >> addRemoveClass: changeDictionary to: eventFactory [
	| definitionSource classBuilder classDefinition |
	definitionSource := changeDictionary at: 'code'.
	self validateClassDefinitionSource: definitionSource.
	classBuilder := self class compiler evaluate: definitionSource.
	classBuilder class = ShiftClassBuilder
		ifFalse: [ self
				error: 'Supplied class definition evaluates to a ' , classBuilder class name asString
						, ', not a ShiftClassBuilder' ].
	classDefinition := classBuilder asRingDefinition.
	eventFactory removeClass: classDefinition tags: (self tagsUsing: eventFactory)
]

{ #category : #private }
GtLToolForRemoteExampleMethodsRun >> addRemoveMethod: changeDictionary to: eventFactory [ 
	| methodClass ast methodDefinition |
	
	methodClass := self class environment classOrTraitNamed:
		(changeDictionary at: 'class').
	ast := RBParser parseMethod: (changeDictionary at: 'code').
	methodDefinition := eventFactory
		methodDefinitionSelector: ast selector
		className: methodClass name
		meta: methodClass isMeta
		package: methodClass package asRingDefinition
		protocol: 'llm-generated'
		sourceCode: ast sourceCode
		stamp: 'llm ', DateAndTime now printString.
	eventFactory 
		removeMethod: methodDefinition 
		tags: (self tagsUsing: eventFactory).
]

{ #category : #api }
GtLToolForRemoteExampleMethodsRun >> allChangesFromLocal: customChanges image: imageChanges [

	^ GtRrImageSyncEvents new
		sessionHistory: GtRrChangesSync uniqueInstance sessionHistory;
		events: imageChanges, customChanges.
]

{ #category : #api }
GtLToolForRemoteExampleMethodsRun >> changesArrayFromArguments: arguments [
	| changesString changes |

	changesString := arguments at: 'changes' ifAbsent: [ ^ #() ].
	changesString ifEmpty: [ ^ #() ].
	changes := STONJSON fromString: changesString.
	changes isArray ifFalse:
		[ self error: 'changes must be an Array, not a ', changes class name ].
	^ changes
]

{ #category : #api }
GtLToolForRemoteExampleMethodsRun >> checkNamesFromArguments: arguments [
	| checkNames |

	checkNames := STONJSON fromString: (arguments
			at: 'checkNames'
			ifAbsent: [ self error: 'Check names not provided' ]).
	self validateCheckNames: checkNames.
	^ checkNames
]

{ #category : #api }
GtLToolForRemoteExampleMethodsRun >> checkNamesFromArray: checkNamesArray [

	checkNamesArray ifNil: [ ^ #() ].

	^ checkNamesArray
		collect: [ :each | 
			| fields selector |
			fields := '>>' split: each.
			selector := fields second.
			selector first = $# ifTrue: [ selector := selector allButFirst ].
			fields first asString -> selector asSymbol ]
]

{ #category : #private }
GtLToolForRemoteExampleMethodsRun >> customChangesFromArray: changesArray [
	"Convert changes supplied by the LLM to OmEntries.
	Only method changes are handled at the moment."
	| eventFactory |

	eventFactory := GtEpiceaEventFactory new.
	changesArray do: [ :changeDictionary | | type |
		type := changeDictionary at: 'type'.
		type = 'method' ifTrue:
			[ self addMethod: changeDictionary to: eventFactory ]
		ifFalse: [ type = 'class' ifTrue:
			[ self addClass: changeDictionary to: eventFactory ]
		ifFalse: [ type = 'removeMethod' ifTrue:
			[ self addRemoveMethod: changeDictionary to: eventFactory]
		ifFalse: [ type = 'removeClass' ifTrue:
			[ self addRemoveClass: changeDictionary to: eventFactory]
		ifFalse:
			[ self error: 'Unknown type: ', type printString. ] ] ] ] ].
	^ eventFactory entries.
]

{ #category : #accessing }
GtLToolForRemoteExampleMethodsRun >> description [
	^ 'Execute gtExample methods using the remote runner.
- checkNames is an array of method names to run, e.g. ''ExampleClass>>exampleMethod''.
- changes is an array of methods to modify, a dictionary with type=''method'', class=the class name, and code=the method source code.'
]

{ #category : #private }
GtLToolForRemoteExampleMethodsRun >> errorReport: report exception: ex [

	report at: 'error' put: {
		'message' -> ex messageText.
		'stackTrace' -> (self stackTraceFor: ex).
		} asDictionary.
]

{ #category : #api }
GtLToolForRemoteExampleMethodsRun >> imageChanges [

	^ GtRrChangesSync uniqueInstance changesFrom:
		GtRrChangesSync uniqueInstance sessionHistory first
]

{ #category : #accessing }
GtLToolForRemoteExampleMethodsRun >> name [
	^ 'runExampleMethods'
]

{ #category : #accessing }
GtLToolForRemoteExampleMethodsRun >> parameters [
	^ #('checkNames' 'changes')
]

{ #category : #'llm-generated' }
GtLToolForRemoteExampleMethodsRun >> privateIsTrueValue: aValue [
	aValue isNil ifTrue: [ ^ false ].
	(aValue = true) ifTrue: [ ^ true ].
	(aValue = false) ifTrue: [ ^ false ].
	(aValue respondsTo: #asString)
		ifTrue: [ ^ aValue asString asLowercase = 'true' ].
	^ false
]

{ #category : #api }
GtLToolForRemoteExampleMethodsRun >> privatePerformToolCall: aToolCall [
	| arguments checkNamesArray changesArray checkNames customChanges imageChanges imageSyncEvents job results runner jobSemaphore report |

	report := Dictionary new.
	[ [
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	checkNamesArray := self checkNamesFromArguments: arguments.
	changesArray := self changesArrayFromArguments: arguments.
	runner := GtRemoteRunner new.
	jobSemaphore := Semaphore new.
	checkNames := self checkNamesFromArray: checkNamesArray.
	customChanges := self customChangesFromArray: changesArray.
	imageChanges := self imageChanges.
	imageSyncEvents := self allChangesFromLocal: customChanges image: imageChanges.
	runner
		managerStartupAndShutdown: GtRrLocalManagerStartupAndShutdown new;
		changesSyncEvents: imageSyncEvents;
		startLogging.
	runner managerStartupAndShutdown poolSize: 2.
	runner start.
	job := (GtRrExplicitExampleTask checkNames: checkNames) asJob.
	job
		when: GtRrJobCompletedAnnouncement
		do: [ :ann | jobSemaphore signal ]
		for: job.
	runner submitJob: job.
	(jobSemaphore waitTimeoutSeconds: 300)
		ifTrue: [ runner stop.
			self
				addErrorMessage: 'Timeout before result received'
				to: report.
			^ STONJSON toString: report ].
	(job hasErrors and: [ job errorDetails isNotNil ])
		ifTrue: [ self
				addErrorMessage: 'Job completed with errors: ' , job errorDetails asString
				to: report ].
	results := job results ifNil: [ #() ].
	results isEmpty
		ifTrue: [ self addErrorMessage: 'Job completed, but has no results' to: report ]
		ifFalse: [ self reportResults: results on: report ] ]
		on: Error
		do: [ :ex | self errorReport: report exception: ex ] ] ensure: [ runner ifNotNil: [ runner stop ] ].
	^ STONJSON toString: report
]

{ #category : #api }
GtLToolForRemoteExampleMethodsRun >> reportResults: results on: report [ 
	| checkResults |

	checkResults := OrderedCollection new.
	results do: [ :task |
		task hasErrors ifTrue:
			[ self addErrorDetails: task errorDetails to: report ]
		ifFalse: [ task result do: [ :result | | checkResult |
			checkResult := Dictionary new.
			checkResult 
				at: 'class' put: result checkName key asString;
				at: 'method' put: result checkName value asString;
				at: 'result' put: result shortName.
			result isSuccess ifFalse:
				[ checkResult 
					at: 'message' put: result exceptionMessageText;
					at: 'stackTrace' put: result exceptionTrace ].
			checkResults add: checkResult ] ] ].
	report at: #results put: checkResults asArray.
]

{ #category : #private }
GtLToolForRemoteExampleMethodsRun >> stackTraceFor: ex [ 

	^ String streamContents: [ :stream |
		ex signalerContext errorReportOn: stream ]
]

{ #category : #private }
GtLToolForRemoteExampleMethodsRun >> tagsUsing: eventFactory [ 
	| index |

	index := eventFactory entries size.
	
	^ (Array streamContents: [ :stream |
		stream
			nextPut: #author -> self class name asString;
			nextPut: #time -> DateAndTime now printString.
		index > 0 ifTrue:
			[ stream
				nextPut: #prior -> (OmReference
					globalName: self class name
					localName: index asString) ].
		stream nextPut: #self -> (OmReference
			globalName: self class name
			localName: (index + 1) asString). ])
				asDictionary
		.
]

{ #category : #api }
GtLToolForRemoteExampleMethodsRun >> validateCheckNames: checkNamesArray [

	checkNamesArray isArray ifFalse:
		[ self error: 'checkNames must be an Array, not a ', checkNamesArray class name ].
	(checkNamesArray allSatisfy: [ :name | name isString ]) ifFalse:
		[ self error: 'checkNames must be an Array of strings of format "ClassName>>methodName"' ].
]

{ #category : #private }
GtLToolForRemoteExampleMethodsRun >> validateClassDefinitionSource: definitionSource [
	"The class definition source is considered valid if it sends the message #<< to what looks like a class or directly references ShiftClassBuilder."
	| ast allChildren isShiftClassBuilder doesntBuildOrInstall |

	ast := RBParser parseExpression: definitionSource.
	allChildren := ast allChildren.
	isShiftClassBuilder := allChildren anySatisfy: [ :child |
		(child isMessage and: 
		[ child selector = #<< and:
		[ child receiver isVariable and:
		[ child receiver name first isUppercase ] ] ]) or:
			[ child isMessage and:
			[ child receiver isVariable and:
			[ child receiver name first isUppercase and:
			[ child receiver name = #ShiftClassBuilder ] ] ] ] ].
	isShiftClassBuilder ifFalse:
		[ self error: 'Supplied class definition doesn''t use the ShiftClassBuilder' ].
	doesntBuildOrInstall := allChildren noneSatisfy: [ :child |
		child isMessage and:
		[ #(build install) includes: child selector ] ].
	doesntBuildOrInstall ifFalse:
		[ self error: 'Supplied class definition attempts to build or install the class' ].
]
