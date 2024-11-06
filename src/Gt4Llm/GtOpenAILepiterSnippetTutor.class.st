Class {
	#name : #GtOpenAILepiterSnippetTutor,
	#superclass : #GtOpenAIAnnotatedActionTutor,
	#category : #'Gt4Llm-Tutor'
}

{ #category : #'as yet unclassified' }
GtOpenAILepiterSnippetTutor >> forSnippet: snippet [
	self
		valuePipelineFor: (GtLlmSerializableValueHolder new
				content: snippet;
				name: 'Snippet';
				serializer: [ :aSnippet | LeJsonV4 uniqueInstance serializePretty: aSnippet ];
				updater: [ :aSnippet :aText | aSnippet become: (LeJsonV4 uniqueInstance deserialize: aText readStream) ])
]

{ #category : #'as yet unclassified' }
GtOpenAILepiterSnippetTutor >> formatName [
	^ 'serialized Lepiter snippet'
]

{ #category : #'as yet unclassified' }
GtOpenAILepiterSnippetTutor >> gtSnippetFormatComponent [
	<gtLlmFormatComponent>
	^ GtLlmTutorFormatComponent new
	type: ((OrderedCollection new) add: 'string'; add: 'null'; yourself);
	format: 'JSON';
	name: 'Snippet';
	priority: 10;
	example: '{
	"__schema" : "4.1",
	"__type" : "pythonSnippet",
	"children" : {
		"__type" : "snippets",
		"items" : [ ]
	},
	"createEmail" : {
		"__type" : "email",
		"emailString" : "veit.heller@feenk.com"
	},
	"createTime" : {
		"__type" : "time",
		"time" : {
			"__type" : "dateAndTime",
			"dateAndTimeString" : "2024-11-06T11:11:26.886128+01:00"
		}
	},
	"editEmail" : {
		"__type" : "email",
		"emailString" : "veit.heller@feenk.com"
	},
	"editTime" : {
		"__type" : "time",
		"time" : {
			"__type" : "dateAndTime",
			"dateAndTimeString" : "2024-11-06T12:49:39.273242+01:00"
		}
	},
	"uid" : {
		"__type" : "uid",
		"uidString" : "rY1Nep3iDQCA1/mhBoyAsw=="
	},
	"code" : "import datetime\rdatetime.datetime.now()5"
}'
]

{ #category : #'as yet unclassified' }
GtOpenAILepiterSnippetTutor >> messageClass [
	^ GtOpenAILepiterSnippetThreadMessage
]
