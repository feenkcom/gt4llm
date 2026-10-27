"
Agent Client Protocol v1 integration for Glamorous Toolkit. See GtLACPExamples for executable usage.
"
Class {
	#name : #GtLACPClient,
	#superclass : #GtLACPObject,
	#instVars : [
		'configuration',
		'sessions',
		'connections',
		'transportFactory'
	],
	#category : #'Gt4Llm-ACP-Core'
}

{ #category : #sessions }
GtLACPClient >> applyPreferencesTo: aSession [
 configuration mode ifNotNil: [ :value | aSession setMode: value ].
 configuration model ifNotNil: [ :value | aSession setModel: value ]
]

{ #category : #accessing }
GtLACPClient >> configuration [
 ^ configuration
]

{ #category : #accessing }
GtLACPClient >> configuration: anObject [
 configuration := anObject
]

{ #category : #sessions }
GtLACPClient >> connectionIn: aDirectory [
 | aConnection |
 configuration validate.
 aConnection := GtLACPConnection new
  requestTimeout: configuration requestTimeout;
  transport: (transportFactory value: configuration value: aDirectory);
  yourself.
 connections add: aConnection.
 [ aConnection start.
 configuration authenticationMethod ifNotNil: [ :method | aConnection authenticate: method ] ]
  on: Error do: [ :ex | aConnection stop. ex pass ].
 ^ aConnection
]

{ #category : #accessing }
GtLACPClient >> connections [
 ^ connections
]

{ #category : #accessing }
GtLACPClient >> connections: anObject [
 connections := anObject
]

{ #category : #accessing }
GtLACPClient >> defaultConfiguration [
 ^ self subclassResponsibility
]

{ #category : #views }
GtLACPClient >> gtConfigurationFor: aView [
 <gtView>
 ^ aView forward title: 'Launch'; priority: 5;
  object: [ configuration ]; view: #gtLaunchFor:
]

{ #category : #views }
GtLACPClient >> gtConnectionsFor: aView [
 <gtView>
 ^ aView list title: 'Connections'; priority: 20; items: [ connections ]; itemText: #yourself; actionUpdateButtonTooltip: 'Refresh connections'
]

{ #category : #views }
GtLACPClient >> gtSessionsFor: aView [
 <gtView>
 ^ aView list title: 'Sessions'; priority: 20; items: [ sessions ]; itemText: #yourself; actionUpdateButtonTooltip: 'Refresh sessions'
]

{ #category : #actions }
GtLACPClient >> gtStartSessionFor: anAction [
 <gtAction>
 ^ anAction button label: 'Start session in directory'; priority: 1;
  action: [ :button |
   | directory |
   directory := UIManager default chooseDirectory: 'Choose agent working directory'.
   directory ifNotNil: [
    [ | aSession |
     aSession := self startSessionIn: directory.
     button enqueueTask: (BlTaskAction new action: [ button phlow spawnObject: aSession ]) ] fork ] ]
]

{ #category : #actions }
GtLACPClient >> gtStopFor: anAction [
 <gtAction>
 ^ anAction button label: 'Stop'; priority: 50; action: [ self stop ]
]

{ #category : #accessing }
GtLACPClient >> initialize [
 super initialize.
 configuration := self defaultConfiguration.
 sessions := OrderedCollection new.
 connections := OrderedCollection new.
 transportFactory := [ :aConfiguration :aDirectory |
  GtLACPStdioTransport new agentProcess: (GtLACPProcess new configuration: aConfiguration; directory: aDirectory; yourself); yourself ]
]

{ #category : #sessions }
GtLACPClient >> loadSession: anId in: aDirectory [
 | aConnection aSession |
 aDirectory asFileReference isDirectory ifFalse: [ self error: 'Session directory must exist' ].
 aConnection := self connectionIn: aDirectory asFileReference asAbsolute.
 [ aSession := self newSessionIn: aDirectory connection: aConnection.
 aSession load: anId ]
 on: Error do: [ :ex | aConnection stop. ex pass ].
 ^ aSession
]

{ #category : #sessions }
GtLACPClient >> newSessionIn: aDirectory connection: aConnection [
 | aSession |
 aSession := GtLACPSession new client: self; directory: aDirectory asFileReference asAbsolute; connection: aConnection; yourself.
 sessions add: aSession.
 ^ aSession
]

{ #category : #accessing }
GtLACPClient >> sessions [
 ^ sessions
]

{ #category : #accessing }
GtLACPClient >> sessions: anObject [
 sessions := anObject
]

{ #category : #sessions }
GtLACPClient >> startSessionIn: aDirectory [
 | aReference aConnection aSession |
 aReference := aDirectory asFileReference asAbsolute.
 aReference isDirectory ifFalse: [ self error: 'Session directory must exist' ].
 aConnection := self connectionIn: aReference.
 [ aSession := self newSessionIn: aReference connection: aConnection.
 aSession create.
 self applyPreferencesTo: aSession ]
 on: Error do: [ :ex | aConnection stop. ex pass ].
 ^ aSession
]

{ #category : #lifecycle }
GtLACPClient >> stop [
 connections do: #stop
]

{ #category : #accessing }
GtLACPClient >> transportFactory [
 ^ transportFactory
]

{ #category : #accessing }
GtLACPClient >> transportFactory: anObject [
 transportFactory := anObject
]
