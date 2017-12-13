#!/bin/bash
rm ~/logs/cdx.log
echo '' >~/app/.java-buildpack/language_server_node_cdx/cdx_lsp_server.log
ln -s ~/app/.java-buildpack/language_server_node_cdx/cdx_lsp_server.log ~/logs/cdx.log
