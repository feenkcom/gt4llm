Class {
	#name : #GtLlmToolForRemoteExampleMethodsRun,
	#superclass : #GtLlmAbstractFunctionTool,
	#category : #'Gt4Llm-GToolkit'
}

{ #category : #accessing }
GtLlmToolForRemoteExampleMethodsRun class >> leJsonV4Name [
	^ #gtLlmToolForRemoteExampleMethodsRun
]

{ #category : #private }
GtLlmToolForRemoteExampleMethodsRun >> addErrorDetails: aGtRrErrorDetails to: report [

	report at: 'taskError' put: {
		'message' -> aGtRrErrorDetails errorMessage.
		'stackTrace' -> aGtRrErrorDetails trace. }
			asDictionary.
]

{ #category : #private }
GtLlmToolForRemoteExampleMethodsRun >> addErrorMessage: aString to: reportDictionary [

	reportDictionary at: 'errors' put:
		(reportDictionary at: 'errors' 
			ifPresent: [ :errors | errors copyWith: aString ]
			ifAbsent: [ { aString } ])
]

{ #category : #private }
GtLlmToolForRemoteExampleMethodsRun >> addMethod: changeDictionary to: eventFactory [ 
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

{ #category : #api }
GtLlmToolForRemoteExampleMethodsRun >> allChangesFromLocal: customChanges image: imageChanges [

	^ GtRrImageSyncEvents new
		sessionHistory: GtRrChangesSync uniqueInstance sessionHistory;
		events: imageChanges, customChanges.
]

{ #category : #api }
GtLlmToolForRemoteExampleMethodsRun >> checkNamesFromArray: checkNamesArray [

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
GtLlmToolForRemoteExampleMethodsRun >> customChangesFromArray: changesArray [
	"Convert changes supplied by the LLM to OmEntries.
	Only method changes are handled at the moment."
	| eventFactory |

	eventFactory := GtEpiceaEventFactory new.
	changesArray do: [ :changeDictionary | | type |
		type := changeDictionary at: 'type'.
		type = 'method' ifTrue:
			[ self addMethod: changeDictionary to: eventFactory ]
		ifFalse:
			[ self error: 'Unknown type: ', type printString. ] ].
	^ eventFactory entries.
]

{ #category : #accessing }
GtLlmToolForRemoteExampleMethodsRun >> description [
	^ 'Execute gtExample methods using the remote runner.
- checkNames is an array of method names to run, e.g. ''ExampleClass>>exampleMethod''.
- changes is an array of methods to modify, a dictionary with type=''method'', class=the class name, and code=the method source code.'
]

{ #category : #private }
GtLlmToolForRemoteExampleMethodsRun >> errorReport: report exception: ex [

	report at: 'error' put: {
		'message' -> ex messageText.
		'stackTrace' -> (self stackTraceFor: ex).
		} asDictionary.
]

{ #category : #api }
GtLlmToolForRemoteExampleMethodsRun >> imageChanges [

	^ GtRrChangesSync uniqueInstance changesFrom:
		GtRrChangesSync uniqueInstance sessionHistory first
]

{ #category : #accessing }
GtLlmToolForRemoteExampleMethodsRun >> name [
	^ 'remoteExampleMethodsRun'
]

{ #category : #accessing }
GtLlmToolForRemoteExampleMethodsRun >> parameters [
	^ #('checkNames' 'changes')
]

{ #category : #'llm-generated' }
GtLlmToolForRemoteExampleMethodsRun >> privateIsTrueValue: aValue [
	aValue isNil ifTrue: [ ^ false ].
	(aValue = true) ifTrue: [ ^ true ].
	(aValue = false) ifTrue: [ ^ false ].
	(aValue respondsTo: #asString)
		ifTrue: [ ^ aValue asString asLowercase = 'true' ].
	^ false
]

{ #category : #api }
GtLlmToolForRemoteExampleMethodsRun >> privatePerformToolCall: aToolCall [
	| arguments checkNamesArray changesArray checkNames customChanges imageChanges imageSyncEvents job results runner jobSemaphore report |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	checkNamesArray := arguments
			at: 'checkNames'
			ifAbsent: [ ^ 'Check names not provided' ].
	changesArray := arguments at: 'changes' ifAbsent: [  ].
	report := Dictionary new.
	runner := GtRemoteRunner new.
	jobSemaphore := Semaphore new.
	[ [ checkNames := self checkNamesFromArray: checkNamesArray.
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
			^ 'Timeout before result received' ].
	(job hasErrors and: [ job errorDetails isNotNil ])
		ifTrue: [ self addErrorMessage: 'Job completed with errors: ' , job errorDetails asString to: report ].
	results := job results ifNil: [ #() ].
	results isEmpty
		ifTrue: [ self addErrorMessage: 'Job completed, but has no results' to: report ]
		ifFalse: [ self reportResults: results on: report ] ]
			on: Error
			do: [ :ex | self errorReport: report exception: ex ] ] ensure: [ runner stop ].
	^ STONJSON toString: report
]

{ #category : #api }
GtLlmToolForRemoteExampleMethodsRun >> reportResults: results on: report [ 
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
GtLlmToolForRemoteExampleMethodsRun >> stackTraceFor: ex [ 

	^ String streamContents: [ :stream |
		ex signalerContext errorReportOn: stream ]
]

{ #category : #private }
GtLlmToolForRemoteExampleMethodsRun >> tagsUsing: eventFactory [ 
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
