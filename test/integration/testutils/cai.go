/**
 * Copyright 2024 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// Package cai provides a set of helpers to interact with Cloud Asset Inventory
package utils

import (
	"testing"
	"time"

	"github.com/GoogleCloudPlatform/cloud-foundation-toolkit/infra/blueprint-test/pkg/gcloud"
	"github.com/tidwall/gjson"
)

type CmdCfg struct {
	sleep     int // minutes to sleep prior to CAI retreval. default: 2
	assetType string // asset type to retrieve. default: all
}

type cmdOption func(*CmdCfg)

// newCmdConfig sets defaults and options
func newCmdConfig(opts ...cmdOption) (*CmdCfg) {
	caiOpts := &CmdCfg{
		sleep:     2,
		assetType: "",
	}

	for _, opt := range opts {
		opt(caiOpts)
	}

	return caiOpts
}

// Set custom sleep minutes
func WithSleep(sleep int) cmdOption {
	return func(f *CmdCfg) {
		f.sleep = sleep
	}
}

// Set asset type
func WithAssetType(assetType string) cmdOption {
	return func(f *CmdCfg) {
		f.assetType = assetType
	}
}

// GetProjectResources returns the cloud asset inventory resources for a project as a gjson.Result
func GetProjectResources(t testing.TB, project string, opts ...cmdOption) gjson.Result {
	caiOpts := newCmdConfig(opts...)
	time.Sleep(time.Duration(caiOpts.sleep) * time.Minute)
	if caiOpts.assetType != "" {
		return gcloud.Runf(t, "asset list --project=%s --asset-types=%s --content-type=resource", project, caiOpts.assetType)
	} else {
		return gcloud.Runf(t, "asset list --project=%s --content-type=resource", project)
	}
}
