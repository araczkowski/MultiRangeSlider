create or replace package body multi_range_slider_plugin is

  /*
   * DEMO DATA
   *
   create table multi_range_slider_data(mrs_id varchar2(4000), mrs_data varchar2(4000))
   1  mrs1  [[390,480],[720,840],[960,1140]]
   2  mrs2  [[390,480],[720,1140]]
   3  mrs3  [[390,1140]]
   *
  */

  function render(p_region              in apex_plugin.t_region,
                  p_plugin              in apex_plugin.t_plugin,
                  p_is_printer_friendly in boolean)
    return apex_plugin.t_region_render_result is

    -- Component attributes
    l_min       apex_application_page_regions.attribute_01%type := coalesce(p_region.attribute_01,
                                                                            '0');
    l_max       apex_application_page_regions.attribute_02%type := coalesce(p_region.attribute_02,
                                                                            '1440');
    l_step      apex_application_page_regions.attribute_03%type := coalesce(p_region.attribute_03,
                                                                            '30');
    l_gap       apex_application_page_regions.attribute_04%type := coalesce(p_region.attribute_04,
                                                                            '150');
    l_newlength apex_application_page_regions.attribute_05%type := coalesce(p_region.attribute_05,
                                                                            '90');

    l_handleLabelDispFormat apex_application_page_regions.attribute_06%type := coalesce(p_region.attribute_06,
                                                                                        'function(steps) {var hours = Math.floor(Math.abs(steps) / 60); var minutes = Math.abs(steps) % 60; return ((hours < 10 && hours >= 0) ? "0" : "") + hours + ":" + ((minutes < 10 && minutes >= 0) ? "0" : "") + minutes; }');

    l_stepLabelDispFormat apex_application_page_regions.attribute_07%type := coalesce(p_region.attribute_07,
                                                                                      'function(steps) {var hours = Math.floor(Math.abs(steps) / 60);return Math.abs(steps) % 60 === 0 ? ((hours < 10 && hours >= 0) ? "0" : "") + hours : ""; }');

    --
    l_elementId      apex_application_page_regions.attribute_08%type := p_region.attribute_08;
    l_first_instance apex_application_page_regions.attribute_09%type := coalesce(p_region.attribute_09,
                                                                                 'Y');
    l_options        JSON := json();
    retval           apex_plugin.t_region_render_result;
    cursor c_slider_data(pc_mrs_id varchar2) is
      select * from multi_range_slider_data m where m.mrs_id = pc_mrs_id;
    r_slider_data c_slider_data%rowtype;
  begin
    if apex_application.g_debug then
      apex_plugin_util.debug_region(p_plugin => p_plugin,
                                    p_region => p_region);
    end if;

    -- load the css and js only for first plugin instance
    if l_first_instance = 'Y' then
      -- CSS files
      apex_css.add_file(p_name      => 'vendor',
                        p_directory => p_plugin.file_prefix);

      apex_css.add_file(p_name      => 'main',
                        p_directory => p_plugin.file_prefix);

      -- JS files
      apex_javascript.add_library(p_name      => 'vendor',
                                  p_directory => p_plugin.file_prefix,
                                  p_version   => null);

      apex_javascript.add_library(p_name      => 'main',
                                  p_directory => p_plugin.file_prefix,
                                  p_version   => null);
    end if;

    -- html part
    sys.htp.p('<script>var ' || l_elementId || '</script>');
    sys.htp.p('<div id="content-' || l_elementId ||
              '" class="content"><div id="' || l_elementId ||
              '"></div></div>');

    --  plugin inicialization
    l_options.put(pair_name => 'min', pair_value => l_min);
    l_options.put(pair_name => 'max', pair_value => l_max);
    l_options.put(pair_name => 'step', pair_value => l_step);
    l_options.put(pair_name => 'gap', pair_value => l_gap);
    l_options.put(pair_name => 'newlength', pair_value => l_newlength);
    l_options.put(pair_name  => 'handleLabelDispFormat',
                  pair_value => l_handleLabelDispFormat);
    l_options.put(pair_name  => 'stepLabelDispFormat',
                  pair_value => l_stepLabelDispFormat);

    apex_javascript.add_onload_code(p_code => l_elementId || ' = new Mrs("' ||
                                              l_elementId || '",' ||
                                              l_options.to_char || ');');

    open c_slider_data(l_elementId);
    fetch c_slider_data
      into r_slider_data;
    if c_slider_data%found then
      apex_javascript.add_onload_code(p_code => r_slider_data.mrs_id ||
                                                '.addPeriods(' ||
                                                r_slider_data.mrs_data || ');');
    end if;

    close c_slider_data;

    return retval;
  end render;

  -- test
  procedure save_data(p_id varchar2, p_data varchar2) is
    l_count number;
  begin
    select count(1)
      into l_count
      from multi_range_slider_data
     where mrs_id = p_id;

    if l_count > 0 then
      update multi_range_slider_data
         set mrs_data = p_data
       where mrs_id = p_id;
    else
      insert into multi_range_slider_data
        (mrs_id, mrs_data)
      values
        (p_id, p_data);
    end if;
  end;
end multi_range_slider_plugin;
/
