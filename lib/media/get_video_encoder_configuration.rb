require_relative '../action'

module ONVIF
    module MediaAction
        class GetVideoEncoderConfiguration < Action
            # c_token 的结构  // [ReferenceToken]  Token of the requested video encoder configuration.
            def run c_token, cb
                message = Message.new
                message.body =  ->(xml) do
                    xml.wsdl(:GetVideoEncoderConfiguration) do
                        xml.wsdl :ConfigurationToken, c_token
                    end
                end
                send_message message do |success, result|
                    if success
                        xml_doc = Nokogiri::XML(result[:content])
                        options = {
                            quality_range: _get_min_max(_get_node(xml_doc, "//tt:QualityRange")),
                            jpeg: {
                                resolutions_available: _get_each_val(_get_node(xml_doc, "//tt:JPEG"), "//tt:ResolutionsAvailable"),
                                frame_rate_range: _get_min_max(_get_node(xml_doc, "//tt:JPEG"), "//tt:FrameRateRange"),
                                rncoding_interval_range: _get_min_max(_get_node(xml_doc, "//tt:JPEG"), "//tt:FrameRateRange")
                            },
                            mpeg4: {
                                resolutions_available: _get_each_val(_get_node(xml_doc, "//tt:MPEG4"), "//tt:ResolutionsAvailable"),
                                gov_length_range: _get_min_max(_get_node(xml_doc, "//tt:MPEG4"), "//tt:GovLengthRange"),
                                frame_rate_range: _get_min_max(_get_node(xml_doc, "//tt:MPEG4"), "//tt:FrameRateRange"),
                                rncoding_interval_range: _get_min_max(_get_node(xml_doc, "//tt:MPEG4"), "//tt:EncodingIntervalRange"),
                                mpeg4_profiles_supported: _get_profiles_supported(_get_node(xml_doc, "//tt:MPEG4"), "//tt:Mpeg4ProfilesSupported")
                            },
                            h264: {
                                resolutions_available: _get_each_val(_get_node(xml_doc, "//tt:h264"), "//tt:ResolutionsAvailable"),
                                gov_length_range: _get_min_max(_get_node(xml_doc, "//tt:h264"), "//tt:GovLengthRange"),
                                frame_rate_range: _get_min_max(_get_node(xml_doc, "//tt:h264"), "//tt:FrameRateRange"),
                                rncoding_interval_range: _get_min_max(_get_node(xml_doc, "//tt:h264"), "//tt:EncodingIntervalRange"),
                                h264_profiles_supported: _get_profiles_supported(_get_node(xml_doc, "//tt:h264"), "//tt:H264ProfilesSupported")
                            },
                            extension: ""
                        }
                        
                        callback cb, success, options
                    else
                        callback cb, success, result
                    end
                end
            end
            def _get_profiles_supported xml_doc, parent_name
                this_node = xml_doc.at_xpath(parent_name)
                result_val = []
                this_node.each do |node|
                    result_val << node.content
                end
                return result_val
            end
            def _get_node parent_node, node_name
                parent_node.at_xpath(node_name)
            end

            def _get_each_val xml_doc, parent_name
                result_val = []
                xml_doc.each do |node|
                    result_val << _get_width_height(node, parent_name)
                end
                return result_val
            end

            def _get_min_max xml_doc, parent_name
                this_node = xml_doc
                unless parent_name.nil?
                    this_node = xml_doc.at_xpath(parent_name)
                end
                return {
                    min: value(this_node, "tt:Min"),
                    max: value(this_node, "tt:Max")
                }
            end

            def _get_width_height xml_doc, parent_name
                this_node = xml_doc
                unless parent_name.nil?
                    this_node = xml_doc.at_xpath(parent_name)
                end
                return {
                    width: value(this_node, "tt:Width"),
                    height: value(this_node, "tt:Height")
                }
            end
        end
    end
end