Class {
	#name : #GtOpenAIWardleyMapActionTutor,
	#superclass : #GtOpenAIAnnotatedActionTutor,
	#category : #'Gt4OpenAI-Examples - Wardley Map'
}

{ #category : #accessing }
GtOpenAIWardleyMapActionTutor >> addChat [
	| aChat |
	aChat := GtOpenAIWardleyMapActionAssistantChat new
			assistant: self assistant;
			tutor: self;
			actions: actions;
			responseFormat: self format asJsonSchema;
			pipeline: pipelineBuilder value.
	chats add: aChat.

	^ aChat
]

{ #category : #accessing }
GtOpenAIWardleyMapActionTutor >> connectionAction [
	<gtLlmTutorAction>
	^ GtLlmTutorAction new
		name: 'Add new connected nodes';
		priority: 2;
		description: 'Adds new nodes that are connected to an already existing node. It MUST consider the context of the map topic. It MUST return the entirety of the state.';
		format: 'Add new connected nodes to `{1}`';
		examples: {GtLlmTutorActionExample new
					input: {'Action' -> 'Add new connected nodes to `Compute`'.
							'Topic' -> 'Cloud computing'.
							'Wardley Map'
								-> 'style wardley

evolution genesis -> custom built -> product (+rental) -> commodity

component Compute [0.45, 0.34] label [-22, 29]

'} asDictionary;
					output: {'Action' -> 'Add new connected nodes'.
							'Topic' -> 'Cloud computing'.
							'Wardley Map'
								-> 'style wardley

evolution genesis -> custom built -> product (+rental) -> commodity

component Compute [0.45, 0.34] label [-22, 29]
component Platform [0.73, 0.71] label [-26, 29]
component Cloud [0.9, 0.81] label [-26, 29]

Compute->Platform
Compute->Cloud'} asDictionary.
				GtLlmTutorActionExample new
					input: {'Action' -> 'Add new connected nodes to `Regulator`'.
							'Topic' -> 'Regulation'.
							'Wardley Map'
								-> 'style wardley

evolution genesis -> custom built -> product (+rental) -> commodity

component Regulator [0.6, 0.2] label [-22, 29]
'} asDictionary;
					output: {'Action' -> 'Add new connected nodes'.
							'Topic' -> 'Regulation'.
							'Wardley map'
								-> 'style wardley

evolution genesis -> custom built -> product (+rental) -> commodity

component Regulator [0.6, 0.2] label [-22, 29]
component Audit [0.8, 0.8] label [-26, 29]

Regulator->Audit
'} asDictionary}
]

{ #category : #accessing }
GtOpenAIWardleyMapActionTutor >> explanationAction [
	<gtLlmTutorAction>
	^ GtLlmTutorAction new
		name: 'Explain a node';
		priority: 3;
		description: 'Explains what a node means and why it is on the map using human language.';
		format: 'Explain the node `{1}`';
		examples: {GtLlmTutorActionExample new
					input: {'Action' -> 'Explain `Compute`'.
							'Topic' -> 'Cloud computing'.
							'Wardley Map'
								-> 'style wardley

evolution genesis -> custom built -> product (+rental) -> commodity

component Compute [0.4, 0.4] label [-22, 29]'} asDictionary;
					output: {'Action' -> 'Explain a node'.
							'Explanation'
								-> 'In the context of this Wardley Map on Cloud Computing, the node `Compute` refers to the computing resources and capabilities provided as part of cloud services. This encompasses the virtualized processing power (CPUs, GPUs) that can be scaled up or down on demand to meet the needs of applications or services running in the cloud. The `Compute` node is fundamental to cloud computing, as it allows for flexible, efficient, and scalable computing solutions that can be tailored to the specific requirements of businesses and developers.

The presence of `Compute` in a cloud computing map highlights its role as a core component of the cloud value chain, directly supporting various higher-level services and applications that depend on reliable and scalable computing resources. It could be connected to nodes representing services that leverage these computing resources, such as web hosting, data analytics platforms, or any software-as-a-service (SaaS) applications, indicating a dependency relationship where these services rely on the underlying compute capabilities to function effectively.

In summary, `Compute` signifies the provisioning of raw processing power in the cloud, which is pivotal to the delivery of a wide range of cloud-based services and applications, illustrating the utility and flexibility offered by cloud computing paradigms.
```'} asDictionary}
]

{ #category : #accessing }
GtOpenAIWardleyMapActionTutor >> explanationFormatComponent [
	<gtLlmFormatComponent>
	^ GtLlmTutorFormatComponent new
		name: 'Explanation';
		priority: 3;
		format: 'Text';
		example: '```
Human readable text goes here
```'
]

{ #category : #accessing }
GtOpenAIWardleyMapActionTutor >> formatName [
	^ 'Wardley Map'
]

{ #category : #accessing }
GtOpenAIWardleyMapActionTutor >> initialAction [
	<gtLlmTutorAction>
	^ GtLlmTutorAction new
		name: 'Create a set of nodes';
		priority: 1;
		description: 'Creates a set of nodes based on a given topic, filling topic, nodes, and connections with sensible data. If a map topic was already set, it is overridden. The rest of the map is extended.';
		format: 'Create a set of nodes on {1}';
		examples: {GtLlmTutorActionExample new
					input: {'Action'
								-> 'Create a set of nodes on Key components for a drone delivery service'.
							'Topic' -> ''.
							'Wardley Map' -> ''} asDictionary;
					output: {'Action' -> 'Create a set of nodes'.
							'Topic' -> 'Key components for a drone delivery service'.
							'Wardley Map'
								-> 'style wardley

evolution genesis -> custom built -> product (+rental) -> commodity

component Customer need [0.90, 0.95] label [4, -4]

component Drone delivery platform [0.70, 0.80] label [-12, -3]
component Drones [0.60, 0.60] label [-12, 3]
component Maintenance service for drones [0.50, 0.50] label [-22, 35]
component Regulatory compliance [0.30, 0.80] label [-22, 25]
component Weather monitoring system [0.40, 0.50] label [2, 15]
component Navigation and GPS [0.30, 0.60] label [2, 25]
component Air traffic control system [0.20, 0.70] label [-12, 15]
component Automated package handling system [0.50, 0.60] label [-2, -15]
component Communication system [0.40, 0.60] label [12, -15]
component Computing resources [0.20, 0.30] label [-42, -5]
component Data storage [0.20, 0.40] label [-52, -5]
component Cybersecurity measures [0.10, 0.60] label [-52, 15]
component Software development [0.30, 0.20] label [-52, 25]
component Power supply and charging stations [0.20, 0.50] label [22, -5]

Customer need->Drone delivery platform
Drone delivery platform->Drones
Drones->Maintenance service for drones
Drone delivery platform->Regulatory compliance
Drone delivery platform->Weather monitoring system
Drones->Navigation and GPS
Drones->Air traffic control system
Drone delivery platform->Automated package handling system
Drone delivery platform->Communication system
Drone delivery platform->Computing resources
Drones->Power supply and charging stations
Drone delivery platform->Data storage
Drone delivery platform->Software development
Drone delivery platform->Cybersecurity measures'} asDictionary.
				GtLlmTutorActionExample new
					input: {'Action' -> 'Create a set of nodes on Moldable development'.
							'Topic' -> ''.
							'Wardley Map' -> ''} asDictionary;
					output: {'Action' -> 'Create a set of nodes'.
							'Topic' -> 'Moldable development'.
							'Wardley Map'
								-> 'style wardley

evolution genesis -> custom built -> product (+rental) -> commodity

component User Feedback [0.4, 0.85] label [-22, 29]
component Programming Languages [0.8, 0.3] label [-42, 29]
component Problem Domain [0.2, 0.9] label [14, 29]
component Customization Frameworks [0.5, 0.7] label [-62, 29]
component Frameworks and Libraries [0.75, 0.2] label [-82, 29]
component Moldable Tools [0.4, 0.8] label [-102, 29]
component Developer Skills [0.3, 0.7] label [34, 29]
component Development Practices [0.1, 0.1] label [54, 29]

User Feedback->Moldable Tools
User Feedback->Customization Frameworks
Developer Skills->Moldable Tools
Developer Skills->Programming Languages
Developer Skills->Frameworks and Libraries
Moldable Tools->Problem Domain
Customization Frameworks->Problem Domain
Development Practices->Moldable Tools
Development Practices->Customization Frameworks'} asDictionary}
]

{ #category : #accessing }
GtOpenAIWardleyMapActionTutor >> initialize [
	super initialize.

	self initializePipeline
]

{ #category : #accessing }
GtOpenAIWardleyMapActionTutor >> initializePipeline [
	self
		pipelineBuilder: [ GtLlmContext new
				instance: GtLlmActionWardleyMapCreator new;
				isImmutableInstance: true;
				checker: (GtLlmAlternativeCodeStep new
						addAlternative: (GtLlmCompositeCodeStep new
									addStep: GtLlmValueExtractorCodeStep new;
									addStep: GtLlmWardleyMapTopicStep new)
							matching: [ :aContext | aContext lastResult key = 'Topic' ];
						addAlternative: (GtLlmCompositeCodeStep new
									addStep: GtLlmValueExtractorCodeStep new;
									addStep: GtLlmWardleyMapMapStep new)
							matching: [ :aContext | aContext lastResult key = 'Wardley Map' ];
						addAlternative: (GtLlmCompositeCodeStep new
									addStep: GtLlmValueExtractorCodeStep new;
									addStep: GtLlmWardleyMapRenameStep new)
							matching: [ :aContext | aContext lastResult key = 'Rename' ];
						addAlternative: (GtLlmCompositeCodeStep new
									addStep: GtLlmValueExtractorCodeStep new;
									addStep: GtLlmWardleyMapExplanationStep new)
							matching: [ :aContext | aContext lastResult key = 'Explanation' ]) ]
]

{ #category : #accessing }
GtOpenAIWardleyMapActionTutor >> mapFormatComponent [
	<gtLlmFormatComponent>
	^ GtLlmTutorFormatComponent new
		name: 'Wardley Map';
		priority: 2;
		format: 'Wardley Map script language';
		example: '```
style wardley

evolution genesis -> custom built -> product (+rental) -> commodity

component Hello [0.80, 0.20] label [-14, 29]

component Goodbye [0.40, 0.60] label [-22, 29]

component Hello again! [0.60, 0.80] label [-42, 29]


Hello->Goodbye
Goodbye->Hello again!
```'
]

{ #category : #accessing }
GtOpenAIWardleyMapActionTutor >> renameAction [
	<gtLlmTutorAction>
	^ GtLlmTutorAction new
		name: 'Propose renames for node';
		priority: 4;
		description: 'Proposes a sensible number of alternative names for nodes (less than ten, but more than one).';
		format: 'Propose renames for node `{1}`';
		examples: {GtLlmTutorActionExample new
					input: {'Action' -> 'Propose renames for node `Compute`'.
							'Topic' -> 'Cloud computing'.
							'Wardley Map'
								-> 'style wardley

evolution genesis -> custom built -> product (+rental) -> commodity

component Compute [0.45, 0.34] label [-22, 29]'} asDictionary;
					output: {'Action' -> 'Propose renames for node'.
							'Rename' -> '{''Compute'': [''Computational resources'', ''Resources'']}'}
							asDictionary.
				GtLlmTutorActionExample new
					input: {'Action' -> 'Propose renames for node `Furnace`'.
							'Topic' -> 'Appliances'.
							'Wardley Map'
								-> 'style wardley

evolution genesis -> custom built -> product (+rental) -> commodity

component Furance [0.9, 0.9] label [-9, 9]'} asDictionary;
					output: {'Action' -> 'Propose renames for node'.
							'Rename'
								-> '{''Furnace'': [''Boiler'', ''Heater'', ''Incinerator'', ''Kiln'', ''Stove'']}'}
							asDictionary}
]

{ #category : #accessing }
GtOpenAIWardleyMapActionTutor >> renameFormatComponent [
	<gtLlmFormatComponent>
	^ GtLlmTutorFormatComponent new
		name: 'Rename';
		priority: 2;
		format: 'Text';
		example: '```
{''Node name'': [''Proposal A'', ''Proposal B'']}
```'
]

{ #category : #accessing }
GtOpenAIWardleyMapActionTutor >> reviewAction [
	<gtLlmTutorAction>
	^ GtLlmTutorAction new
		name: 'Review the current state';
		priority: 5;
		description: 'Reviews and criticizes the current state of the map.';
		examples: {GtLlmTutorActionExample new
					input: {'Action' -> 'Review the current state'.
							'Topic' -> 'Cloud computing'.
							'Wardley Map'
								-> 'style wardley

evolution genesis -> custom built -> product (+rental) -> commodity

component Compute [0.45, 0.34] label [-22, 29]'} asDictionary;
					output: {'Explanation'
								-> 'The map is incomplete. Currently, only one node is defined. A complete map should have multiple nodes and connections. The current node `Compute` is correct, but misplaced.'}
							asDictionary}
]

{ #category : #accessing }
GtOpenAIWardleyMapActionTutor >> topicFormatComponent [
	<gtLlmFormatComponent>
	^ GtLlmTutorFormatComponent new
		name: 'Topic';
		priority: 1;
		format: 'Text';
		example: '```topic
Cloud computing in regulated areas
```'
]
